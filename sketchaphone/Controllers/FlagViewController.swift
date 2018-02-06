import UIKit
class FlagViewController: LoadingViewController {
    var game: Game?
    var turn: Turn?
    
    @IBOutlet weak var textField: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.text = ""
        textField.becomeFirstResponder()
        
    }
    
    @IBAction func flagTouch(_ sender: UIBarButtonItem) {
        if (textField.text == nil || textField.text == "") {
            alert("Reason cannot be blank")
            return
        }
        gamesManager.flag(game: game!, turn: turn, reason: textField.text)
        //TODO callback
        //TODO saving animation
        startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.stopLoading()
            self.performSegue(withIdentifier: "backToNewGames", sender: self)
        })
    }
    
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

