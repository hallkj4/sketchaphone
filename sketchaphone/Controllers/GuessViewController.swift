import UIKit

class GuessViewController: UIViewController {
    var game: Game?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO if game hasn't been set, error out
        let lastTurn = game?.turns.last
        if (lastTurn == nil) {
            //TODO error
            return
        }
        if (lastTurn?.image == nil) {
            //todo error
            return
        }
        imageView.image = lastTurn!.image
        //TODO unlock the drawing
    }
    
    @IBAction func guessTouch(_ sender: UIBarButtonItem) {
        if (textField.text == nil || textField.text == "") {
            //TODO check for default text
            // TODO alert
            return
        }
        //TODO: prompt the user: are you sure?
        game = nil
        //todo lock the drawing
        //todo loading anim
        dismiss(animated: true) //todo move this to a callback
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        gamesManager.release(game: game!)//TODO callback
        game = nil
        dismiss(animated: true)
    }
}
