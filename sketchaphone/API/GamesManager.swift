import AWSAppSync
import AWSS3

let gamesManager = GamesManager()

protocol GameWatcher {
    func gamesUpdated()
}

protocol JoinGameDelgate {
    func gameJoined()
    func couldNotJoinGame(message: String)
}

class GamesManager {
    var currentGame: OpenGameDetailed?
    var inProgressGames = [OpenGameDetailed]()
    
    var completedGames = [GameDetailed]()
    var myCompletedGames = [GameDetailed]()
    
    var completedGamesNextToken: String?
    var myCompletedGamesNextToken: String?
    
    private var watchers = [GameWatcher]()
    
    let numRounds = 4 //TODO - update this to 9
    
    func new(phrase: String, callback: @escaping (Error?) -> Void) {
        NSLog("attempting to create game: " + phrase)
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
            NSLog("game created: " + phrase)
            self.inProgressGames.append(newGame)
            callback(nil)
            self.notifyWatchers()
        })
    }
    
    func draw(image: UIImage, callback: @escaping (Error?, Bool) -> Void) {
        uploadDrawing(image: image, callback: {(drawing, error) in
            if let error = error {
                callback(error, false)
                return
            }
            appSyncClient!.perform(mutation: TakeTurnMutation(drawing: drawing), resultHandler: {(result, error) in
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
        guard let pngData = UIImagePNGRepresentation(image) else {
            throw GenericError("couldn't make PNG data from image")
        }
        let filePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(key)
        try pngData.write(to: filePath)
        return filePath
    }
    
    func guess(phrase: String, callback: @escaping (Error?, Bool) -> Void) {
        appSyncClient!.perform(mutation: TakeTurnMutation(phrase: phrase), resultHandler: {(result, error) in
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
    
    private func renewLock(callback: @escaping (OpenGameDetailed?, Error?) -> Void) {
        appSyncClient!.perform(mutation: RenewLockMutation(), resultHandler: {(result, error) in
            if let error = error {
                NSLog("Error renewing lock on game: \(error.localizedDescription)")
                callback(nil, error)
                return
            }
            
            guard let game = result?.data?.renewLock.fragments.openGameDetailed else {
                callback(nil, NilDataError())
                return
            }
            callback(game, nil)
        })
    }
    
    func release() {
        appSyncClient?.perform(mutation: ReleaseGameMutation(), resultHandler: {(result, error) in
            if let error = error as? AWSAppSyncClientError {
                NSLog("Error occurred: \(error.localizedDescription )")
                return
            }
            NSLog("lock released successfully")
        })
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
    
    func joinGame(delegate: JoinGameDelgate) {
        NSLog("attempting to join a game")
        appSyncClient!.perform(mutation: JoinGameMutation(), resultHandler: { (result, error) in
            NSLog("joinGame responded, handling response")
            if let error = error as? AWSAppSyncClientError {
                NSLog("could not join game, encountered error: " + error.localizedDescription)
                delegate.couldNotJoinGame(message: error.localizedDescription)
                return
            }
            
            guard let gameRaw = result?.data?.joinGame else {
                NSLog("could not join game: no games were found")
                delegate.couldNotJoinGame(message: "No games were found")
                return
            }
            let game = gameRaw.fragments.openGameDetailed
            NSLog("Joined a game: " + game.id)
            self.currentGame = game
            delegate.gameJoined()
            //TODO set a timer and lock game every so often
        })
    }
    
    func fetchInProgressGames() {
        NSLog("fetching inprogress games")
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
            NSLog("got \(self.inProgressGames.count) inProgress games")
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
