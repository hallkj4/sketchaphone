import UIKit

class DrawViewController: UIViewController, UIScrollViewDelegate {
    var game: Game?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var imageView: DrawableImageView!
    
    //TODO - erasor
    
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
        
        imageView.image = UIImage()
        //TODO unlock the drawing
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first!
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
