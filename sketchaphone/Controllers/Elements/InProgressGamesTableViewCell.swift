import UIKit

class InProgressGamesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!

    func draw() {
        label.text = "In Progess Games: " + String(completedGameManager.inProgressGames.count)
    }
}
