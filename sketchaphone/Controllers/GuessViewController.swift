import UIKit

class GuessViewController: LoadingViewController, UIScrollViewDelegate, UITextFieldDelegate {
    var game: Game?
    
    let defaultText = "Describe the picture..."
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.zoomScale = 1.0
        
        if (game == nil) {
            alert("game is nil", handler: { _ in
                self.dismiss(animated: false)
            })
        }
        
        let lastTurn = game!.turns.last
        if (lastTurn == nil) {
            alert("lastTurn is nil", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        if (lastTurn?.image == nil) {
            alert("lastTurn did not have an image", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        imageView.image = lastTurn!.image
        textField.textColor = .gray
        textField.text = defaultText
        textField.isEnabled = true
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height + 10, right: 0.0)
        scrollView.zoomScale = 1.0
        scrollView.scrollRectToVisible(textField.frame, animated: false)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == defaultText) {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doGuess()
        return false
    }
    
    @IBAction func guessTouch(_ sender: UIBarButtonItem) {
        doGuess()
    }
    
    func doGuess() {
        if (textField.text == nil || textField.text == "" || textField.text == defaultText) {
            alert("You have to type something.")
            return
        }
        confirm("Are you ready to submit your guess of '\(textField.text!)'?", handler: { confirmed in
            if (confirmed) {
                self.textField.isEnabled = false
                gamesManager.guess(game: self.game!, phrase: self.textField.text!)
                self.game = nil
                //todo loading anim
                self.dismiss(animated: true) //todo move this to a callback
            }
        })
        
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        gamesManager.release(game: game!)//TODO callback
        game = nil
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from guess View")
            return
        }
        switch segue.identifier! {
        case "flag":
            let controller = segue.destination as! FlagViewController
            controller.game = game
            controller.turn = game!.turns.last
        default:
            NSLog("guess View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
}
