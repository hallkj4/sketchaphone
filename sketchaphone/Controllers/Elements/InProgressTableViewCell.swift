import UIKit

class InProgressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var startedByLabel: UILabel!
    @IBOutlet weak var turnsCount: UILabel!
    
    func draw(game: OpenGameDetailed) {
        let firstTurn = game.turns.first
        startedByLabel.text = "Started by: \(firstTurn?.user.name ?? "unknown")"
        phraseLabel.text = "\"" + getPhraseToShow(game: game) + "\""
        
        turnsCount.text = String(gamesManager.numRounds - game.turns.count) + " turns left"
    }
    
    private func findMyTurn(_ game: OpenGameDetailed) -> OpenGameDetailed.Turn? {
        return game.turns.first { turn -> Bool in
            return turn.user.id == userManager.currentUser?.id
        }
    }
    
    private func getPhraseToShow(game: OpenGameDetailed) -> String {
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
