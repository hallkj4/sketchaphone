import AWSAppSync
import AWSS3

let gamesManager = GamesManager()

protocol GameWatcher {
    func gamesUpdated()
}

class GamesManager {
    var openGames = [OpenGameDetailed]()
    var inProgressGames = [OpenGameDetailed]()
    
    var completedGames = [GameDetailed]()
    var myCompletedGames = [GameDetailed]()
    
    var completedGamesNextToken: String?
    var myCompletedGamesNextToken: String?
    
    private var watchers = [GameWatcher]()
    
    let numRounds = 9
    
    let maxGames = 8
    
    func new(phrase: String, callback: @escaping (Error?) -> Void) {
        appSyncClient?.perform(mutation: StartGameMutation(phrase: phrase), resultHandler: { (result, error) in
            if let error = error {
                NSLog("unexpected error type" + error.localizedDescription)
                callback(error)
                return
            }
            
            guard let newGame = result?.data?.startGame.fragments.openGameDetailed else {
                NSLog("game data was not sent")
                callback(NilDataError())
                return
            }
            self.inProgressGames.append(newGame)
            callback(nil)
            self.notifyWatchers()
        })
    }
    
    func draw(game: OpenGameDetailed, image: UIImage, callback: @escaping (Error?, Bool) -> Void) {
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            callback(GenericError("Error! game with no turns!"), false)
            return
        }
        if(lastTurn!.phrase == nil) {
            callback(GenericError("Error: game's last turn is not a phrase!"), false)
            return
        }
        
        uploadDrawing(image: image, callback: {(drawing, error) in
            if let error = error {
                callback(error, false)
                return
            }
            appSyncClient!.perform(mutation: TakeTurnMutation(gameId: game.id, drawing: drawing), resultHandler: {(result, error) in
                if let error = error {
                    NSLog("unexpected error type" + error.localizedDescription)
                    callback(error, false)
                    return
                }
                
                guard let newGame = result?.data?.takeTurn else {
                    NSLog("game data was not sent")
                    callback(NilDataError(), false)
                    return
                }
                if let index = self.openGames.index(where: {$0.id == newGame.id}) {
                    self.openGames.remove(at: index)
                }
                if (newGame.turns.count >= self.numRounds) {
                    self.completedGames.append(newGame.fragments.gameDetailed)
                    self.myCompletedGames.append(newGame.fragments.gameDetailed)
                    callback(nil, true)
                }
                else {
                    self.inProgressGames.append(newGame.fragments.openGameDetailed)
                    callback(nil, false)
                }
                self.notifyWatchers()
            })
        })
        
    }
    
    private func uploadDrawing(image: UIImage, callback: @escaping (S3ObjectInput?, Error?) -> Void) {
        
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            callback(nil, GenericError("couldn't create AWSS3TransferManagerUploadRequest"))
            return
        }
        uploadRequest.key = "\(UUID().uuidString).png"
        uploadRequest.bucket = S3BUCKET
        uploadRequest.contentType = "image/png"
        do {
            try uploadRequest.body = writeToFile(key: uploadRequest.key!, image: image)
        }
        catch {
            callback(nil, GenericError("couldn't write png to file system: \(error.localizedDescription)"))
            return
        }
        
        AWSS3TransferManager.default().upload(uploadRequest).continueWith(block: {(task) in
            if let error = task.error {
                callback(nil, error)
                return nil
            }
            callback(S3ObjectInput(bucket: S3BUCKET, key: uploadRequest.key!, region: AWSRegionString), nil)
            return nil
        })
    }
    
    private func writeToFile(key: String, image: UIImage) throws -> URL {
        //TODO does this need to be async?
        guard let pngData = UIImagePNGRepresentation(image) else {
            throw GenericError("couldn't make PNG data from image")
        }
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        try pngData.write(to: filePath)
        return filePath
    }
    
    
    func guess(game: OpenGameDetailed, phrase: String, callback: @escaping (Error?, Bool) -> Void) {
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            callback(GenericError("Error! game with no turns!"), false)
            return
        }
        if (lastTurn!.drawing == nil) {
            callback(GenericError("Error: game's last turn is not a phrase!"), false)
            return
        }
        
        appSyncClient!.perform(mutation: TakeTurnMutation(gameId: game.id, phrase: phrase), resultHandler: {(result, error) in
            if let error = error {
                NSLog("unexpected error type" + error.localizedDescription)
                callback(error, false)
                return
            }
            
            guard let newGame = result?.data?.takeTurn else {
                NSLog("game data was not sent")
                callback(NilDataError(), false)
                return
            }
            if let index = self.openGames.index(where: {$0.id == newGame.id}) {
                self.openGames.remove(at: index)
            }
            if (newGame.turns.count >= self.numRounds) {
                self.completedGames.append(newGame.fragments.gameDetailed)
                self.myCompletedGames.append(newGame.fragments.gameDetailed)
                callback(nil, true)
            }
            else {
                self.inProgressGames.append(newGame.fragments.openGameDetailed)
                callback(nil, false)
            }
            self.notifyWatchers()
        })
        
    }
    
    //TODO - what should the time limit be on drawing?
    //TODO - prompt that you're running out of time
    
    func lock(game: OpenGameDetailed, callback: @escaping (OpenGameDetailed?, Error?) -> Void) {
        appSyncClient!.perform(mutation: LockGameMutation(id: game.id), resultHandler: {(result, error) in
            //TODO: cleaner prompt for expected error
            if let error = error {
                NSLog("error locking game: \(error.localizedDescription)")
                callback(nil, error)
                return
            }
            
            guard let game = result?.data?.lockGame.fragments.openGameDetailed else {
                NSLog("did not get the locked game!")
                callback(nil, NilDataError())
                return
            }
            if let index = self.openGames.index(where: {$0.id == game.id}) {
                self.openGames.remove(at: index)
            }
            self.openGames.append(game)
            callback(game, nil)
        })
        //TODO set a timer and continue to relock it every 60s
    }
    
    func release(game: OpenGameDetailed) {
        appSyncClient?.perform(mutation: ReleaseGameMutation(id: game.id))
    }
    
    func add(watcher: GameWatcher) {
        watchers.append(watcher)
    }
    
    func flag(game: GameDetailed, reason: String, callback: @escaping (Error?) -> Void) {
        appSyncClient?.perform(mutation: FlagGameMutation(gameId: game.id, reason: reason), resultHandler: {(result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                callback(error)
                return
            }
            callback(nil)
            if let index = self.openGames.index(where: {$0.id == game.id}) {
                self.openGames.remove(at: index)
            }
            if let index = self.inProgressGames.index(where: {$0.id == game.id}) {
                self.inProgressGames.remove(at: index)
            }
            if let index = self.completedGames.index(where: {$0.id == game.id}) {
                self.completedGames.remove(at: index)
            }
            self.notifyWatchers()
        })
        //TODO - remove from the lists
    }
    
    private func notifyWatchers() {
        for watcher in watchers {
            watcher.gamesUpdated()
        }
    }
    
    func fetchOpenGames() {
        appSyncClient!.fetch(query: OpenGamesQuery(), resultHandler: { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let newOpenGames = result?.data?.openGames else {
                NSLog("open games was null")
                return
            }
            self.openGames = newOpenGames.map({$0.fragments.openGameDetailed})
            self.notifyWatchers()
        })
    }
    
    func fetchInProgressGames() {
        appSyncClient!.fetch(query: InProgressTurnsQuery(), resultHandler: { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let inProgressTurns = result?.data?.inProgressTurns else {
                NSLog("inprogressTurns was null")
                return
            }
            self.inProgressGames = inProgressTurns.map({$0.game.fragments.openGameDetailed})
            self.notifyWatchers()
        })
    }
    
    func fetchAllCompletedGames(nextPage: Bool = false) {
        var nextToken: String? = nil
        if (nextPage) {
            nextToken = completedGamesNextToken
        }
        else {
            completedGames.removeAll()
        }
        completedGamesNextToken = nil
        
        appSyncClient!.fetch(query: CompletedGamesQuery(nextToken: nextToken) , resultHandler: { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let gamesRaw = result?.data?.completedGames.games else {
                NSLog("completed games was null")
                return
            }
            self.completedGames = gamesRaw.map{$0.fragments.gameDetailed}
            self.completedGamesNextToken = result?.data?.completedGames.nextToken
            
            self.notifyWatchers()
        })
    }
    
    
    func fetchMyCompletedGames(nextPage: Bool = false) {
        var nextToken: String? = nil
        if (nextPage) {
            nextToken = myCompletedGamesNextToken
        }
        else {
            myCompletedGames.removeAll()
        }
        myCompletedGamesNextToken = nil
        
        appSyncClient!.fetch(query: UserCompletedTurnsQuery(userId: userManager.currentUser!.id, nextToken: nextToken) , resultHandler: { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let turnsRaw = result?.data?.userCompletedTurns.turns else {
                NSLog("completed turns was null")
                return
            }
            self.myCompletedGames = turnsRaw.map{$0.game.fragments.gameDetailed}
            self.myCompletedGamesNextToken = result?.data?.userCompletedTurns.nextToken
            
            self.notifyWatchers()
        })
    }
}
