import UIKit

var gamesManager = GamesManager()

class GamesManager {
    var newGames = [Game]()
    var completedGames = [Game]()
//    let inProgressGames = [Game]()
    
    let rounds = 8
    
    func new(phrase: String) {
        var game = Game()
        let turn = Turn(phrase: phrase)
        game.turns.append(turn)
        newGames.append(game)
        //TODO - push to server
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
        
        guard var mutableGame = newGames.first(where: {$0.id == game.id}) else {
            NSLog("game could not be found")
            return
        }
        
        mutableGame.turns.append(turn)
        //TODO - push to server
        
        checkDone(mutableGame)
    }
    
    func guess(game: Game, phrase: String) {
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            NSLog("Error! game with no turns!")
            return
        }
        if(lastTurn!.image == nil) {
            NSLog("Error: game's last turn is not a phrase!")
            return
        }
        let turn = Turn(phrase: phrase)
        
        guard var mutableGame = newGames.first(where: {$0.id == game.id}) else {
            NSLog("game could not be found")
            return
        }
        mutableGame.turns.append(turn)
        //TODO - push to server
        
        checkDone(mutableGame)
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
    
    private func checkDone(_ game: Game) {
        if (game.turns.count >= rounds) {
            gameFinished(game)
        }
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
