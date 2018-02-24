import AWSAppSync

let gamesManager = GamesManager()

protocol GameWatcher {
    func gamesUpdated()
}

class GamesManager {
    var openGames = [OpenGameDetailed]()
    var inProgressGames = [OpenGameDetailed]()
    
    var completedGames = [GameDetailed]()
    
    var completedGamesNextToken: String?
    
    private var watchers = [GameWatcher]()
    
    let numRounds = 9
    
    let maxGames = 8
    
    func new(phrase: String, callback: @escaping (Error) -> Void) {
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
            self.notifyWatchers()
        })
    }
    
    func draw(game: OpenGameDetailed, image: UIImage) {
        //TODO
//        let drawing = S3ObjectInput(bucket: , key: , region: )
//        TakeTurnMutation(gameId: game.id, drawing: drawing)
//        let lastTurn = game.turns.last
//        if (lastTurn == nil) {
//            NSLog("Error! game with no turns!")
//            return
//        }
//        if(lastTurn!.phrase == nil) {
//            NSLog("Error: game's last turn is not a phrase!")
//            return
//        }
//        let turn = Turn(image: image)
//
//        guard let pngData = UIImagePNGRepresentation(image) else {
//            // generate an error
//            return
//        }
//        NSLog("pngData size: \(pngData.count)")
//
//        //TODO - push to server
//
//        checkDone(game)
    }
    
    
    //todo callback should know if the game was completed...
    func guess(game: OpenGameDetailed, phrase: String, callback: @escaping (Error) -> Void) {
        
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            NSLog("Error! game with no turns!")
            return
        }
        if (lastTurn!.drawing == nil) {
            NSLog("Error: game's last turn is not a phrase!")
            return
        }
        
        appSyncClient!.perform(mutation: TakeTurnMutation(gameId: game.id, phrase: phrase), resultHandler: {(result, error) in
            if let error = error {
                NSLog("unexpected error type" + error.localizedDescription)
                callback(error)
                return
            }
            
            guard let newGame = result?.data?.takeTurn else {
                NSLog("game data was not sent")
                callback(NilDataError())
                return
            }
            if let index = self.openGames.index(where: {$0.id == newGame.id}) {
                self.openGames.remove(at: index)
            }
            if (newGame.turns.count >= self.numRounds) {
                
                self.completedGames.append(newGame.fragments.gameDetailed)
            }
            else {
                self.inProgressGames.append(newGame.fragments.openGameDetailed)
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
    
    func fetchCompletedGames(nextPage: Bool = false) {
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
}
