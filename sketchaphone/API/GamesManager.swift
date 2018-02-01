import UIKit

var gamesManager = GamesManager()

protocol GameWatcher {
    func gamesUpdated()
}

class GamesManager {
    var newGames = [Game]()
    var inProgressGames: [Game] {
        get {
            return newGames
        }
    }
    
    var completedGames = [Game]()
    
    private var watchers = [GameWatcher]()
    
    let rounds = 8
    
    func new(phrase: String) {
        let game = Game()
        let turn = Turn(phrase: phrase)
        game.turns.append(turn)
        newGames.append(game)
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
        guard let index = newGames.index(where: {$0.id == game.id}) else {
            NSLog("game could not be found!")
            return
        }
        newGames.remove(at: index)
        completedGames.append(game)
    }
}
