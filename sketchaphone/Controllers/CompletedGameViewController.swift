import UIKit
import Kingfisher

class CompletedGameViewController: UIViewController {
    var game: GameDetailed?
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        guard let game = game else {
            alert("Game not found.", handler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        completedGameManager.removeNew(game: game)
        var first = true
        for turn in game.turns {
            if (turn.phrase != nil) {
                let label = UILabel()
                if (first) {
                    first = false
                    label.text = "\(turn.user.name) started with clue: \(turn.phrase!)"
                }
                else {
                    label.text = "\(turn.user.name) guessed: \(turn.phrase!)"
                }
                stackView.addArrangedSubview(label)
            }
            else {
                let label = UILabel()
                label.text = "\(turn.user.name) drew"
                stackView.addArrangedSubview(label)
                
                let imageView = UIImageView()
                imageView.kf.setImage(with: turn.imageURL())
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from Completed Game View")
            return
        }
        switch segue.identifier! {
        case "flag":
            let controller = segue.destination as! FlagViewController
            controller.game = game
            controller.turn = nil
        default:
            NSLog("Completed Game View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
}
