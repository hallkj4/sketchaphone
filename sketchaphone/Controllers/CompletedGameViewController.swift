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
        completedGameManager.removeNew(gameId: game.id)
        var first = true
        for turn in game.turns {
            if (turn.phrase != nil) {
                if (first) {
                    first = false
                    addViewWithLabel("\(turn.user.name) started with clue: \(turn.phrase!)")
                }
                else {
                    addViewWithLabel("\(turn.user.name) guessed: \(turn.phrase!)")
                }
            }
            else { // drawing
                addViewWithLabel("\(turn.user.name) drew")
                
                let imageView = UIImageView()
                imageView.backgroundColor = .white
                imageView.kf.setImage(with: turn.imageURL())
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    private func addViewWithLabel(_ text: String) {
        let label = UILabel()
        label.textColor = .white
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        let view = UIView()
        view.addSubview(label)
        stackView.addArrangedSubview(view)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
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
