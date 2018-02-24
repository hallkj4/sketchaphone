import AWSAppSync

let gamesManager = GamesManager()

protocol GameWatcher {
    func gamesUpdated()
}

class GamesManager {
    var openGames = [OpenGamesQuery.Data.OpenGame]()
    var inProgressGames = [Game]()
    
    var completedGames = [Game]()
    
    private var watchers = [GameWatcher]()
    
    let rounds = 9
    
    func new(phrase: String) {
        let game = Game()
        let turn = Turn(phrase: phrase)
        game.turns.append(turn)
        //TODO - should go to in progress first.
        //TODO - push to server
        notifyWatchers()
    }
    
    func draw(game: Game, image: UIImage) {
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            NSLog("Error! game with no turns!")
            return
        }
        if(lastTurn!.phrase == nil) {
            NSLog("Error: game's last turn is not a phrase!")
            return
        }
        let turn = Turn(image: image)
        
        guard let pngData = UIImagePNGRepresentation(image) else {
            // generate an error
            return
        }
        NSLog("pngData size: \(pngData.count)")
        
        game.turns.append(turn)
        //TODO - push to server
        
        checkDone(game)
    }
    
    func guess(game: Game, phrase: String) {
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            NSLog("Error! game with no turns!")
            return
        }
        if (lastTurn!.image == nil) {
            NSLog("Error: game's last turn is not a phrase!")
            return
        }
        let turn = Turn(phrase: phrase)
        

        game.turns.append(turn)
        //TODO - push to server
        
        checkDone(game)
    }
    
    //TODO - what should the time limit be on drawing?
    //TODO - prompt that you're running out of time
    
    func lock(game: Game) {
        //TODO
        //TODO set a timer and continue to relock it every 60s
        //TODO should reload the game in question probably
    }
    
    func release(game: Game) {
        //TODO
    }
    
    func add(watcher: GameWatcher) {
        watchers.append(watcher)
    }
    
    func flag(game: Game, turn: Turn?, reason: String) {
        //TODO - tell the server
        //TODO - remove from the lists
    }
    
    private func notifyWatchers() {
        for watcher in watchers {
            watcher.gamesUpdated()
        }
    }
    
    private func checkDone(_ game: Game) {
        if (game.turns.count >= rounds) {
            gameFinished(game)
        }
        notifyWatchers()
    }
    
    private func gameFinished(_ game: Game) {
        //TODO HOW SHOULD client handle?
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
            self.openGames = newOpenGames
            self.notifyWatchers()
        })
    }
}
