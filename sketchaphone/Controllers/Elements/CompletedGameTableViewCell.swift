import UIKit

class CompletedGameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var startedByLabel: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var turnsCount: UILabel!
    @IBOutlet weak var newLabel: UIView!
    
    func draw(game: GameDetailed) {
        let firstTurn = game.turns.first
        startedByLabel.text = "Started by: \(firstTurn?.user.name ?? "unknown")"
        phraseLabel.text = "\"" + getPhraseToShow(game: game) + "\""
        
        let completed = game.turns.count >= gamesManager.numRounds
        
        if (completed) {
            checkmark.isHidden = false
            turnsCount.isHidden = true
        }
        else {
            checkmark.isHidden = true
            turnsCount.isHidden = false
            turnsCount.text = String(game.turns.count) + "/" + String(gamesManager.numRounds)
        }
        
        newLabel.isHidden = !completedGameManager.isNew(gameId: game.id)
    }
    
    
    private func findMyTurn(_ game: GameDetailed) -> GameDetailed.Turn? {
        return game.turns.first { turn -> Bool in
            return turn.user.id == userManager.currentUser?.id
        }
    }
    
    private func getPhraseToShow(game: GameDetailed) -> String {
        if let myTurn = findMyTurn(game) {
            if let myPhrase = myTurn.phrase {
                return myPhrase
            }
            let previousTurn = game.turns[myTurn.order - 1]
            if let prevPhrase = previousTurn.phrase {
                return prevPhrase
            }
        }
        return game.turns.first?.phrase ?? "unknown"
    }
}
