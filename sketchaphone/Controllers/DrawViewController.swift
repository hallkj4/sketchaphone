import UIKit

class DrawViewController: UIViewController, UIScrollViewDelegate {
    var game: Game?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var imageView: DrawableImageView!
    @IBOutlet weak var editBar: UIStackView!
    
    let colors: [UIColor] = [.black, .white] //, .red, .green, .yellow, .blue]
    var colorButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for color in colors {
            let button = UIButton()
            button.backgroundColor = color
            button.setTitleColor(color.shifted(), for: .normal)
            button.borderColor = .black
            button.borderWidth = 1.0
            if (imageView.color == color) {
                button.setTitle("\u{2713}", for: .normal)
            }
            else {
                button.setTitle(" ", for: .normal)
            }
            button.addTarget(self, action: #selector(colorTouch(sender:)), for: .touchUpInside)
            colorButtons.append(button)
            editBar.insertArrangedSubview(button, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (game == nil) {
            alert("game is nil", handler: { _ in
                self.dismiss(animated: false)
            })
        }
        let lastTurn = game!.turns.last
        if (lastTurn == nil) {
            alert("lastTurn was nil", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        if (lastTurn?.phrase == nil) {
            alert("lastTurn did not have a phrase", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        phraseLabel.text = lastTurn!.phrase
        
        imageView.reset()
        //TODO unlock the drawing
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first!
    }
    
    @objc func colorTouch(sender: UIButton) {
        imageView.color = sender.backgroundColor!
        for colorButton in colorButtons {
            if (colorButton == sender) {
                colorButton.setTitle("\u{2713}", for: .normal)
            }
            else {
                colorButton.setTitle(" ", for: .normal)
            }
        }
    }
    
    @IBAction func undoTouch(_ sender: UIButton) {
        imageView.undo()
    }
    
    @IBAction func clearClick(_ sender: UIButton) {
        imageView.clear()
    }
    
    @IBAction func submitTouch(_ sender: UIBarButtonItem) {
        confirm("Are you ready to submit your drawing?", handler: {confirmed in
            if (confirmed) {
                gamesManager.draw(game: self.game!, image: self.imageView.image!)
                self.game = nil
                //todo lock the drawing
                //todo loading anim
                self.dismiss(animated: true)
            }
        })
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        confirm("Are you sure you want to cancel?", handler: {confirmed in
            if (confirmed) {
                gamesManager.release(game: self.game!)
                self.game = nil
                self.dismiss(animated: true)
            }
        })
    }
}
