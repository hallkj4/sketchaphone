import UIKit

class DrawViewController: UIViewController {
    var game: Game?
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var imageView: DrawableImageView!
    
    //TODO - erasor
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO if game hasn't been set, error out
        let lastTurn = game?.turns.last
        if (lastTurn == nil) {
            //TODO error
            return
        }
        if (lastTurn?.phrase == nil) {
            //todo error
            return
        }
        phraseLabel.text = lastTurn!.phrase
        
        imageView.image = UIImage()
        //TODO unlock the drawing
    }
    
    @IBAction func submitTouch(_ sender: UIBarButtonItem) {
        //TODO: prompt the user: are you sure?
        gamesManager.draw(game: game!, image: imageView.image!)
        game = nil
        //todo lock the drawing
        //todo loading anim
        dismiss(animated: true) //todo move this to a callback
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        gamesManager.release(game: game!)
        game = nil
        dismiss(animated: true)
    }
}
