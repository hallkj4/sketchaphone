import UIKit
import Kingfisher

class GuessViewController: LoadingViewController, UIScrollViewDelegate, UITextFieldDelegate {
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        scrollView.zoomScale = 1.0
        
        guard let game = gamesManager.currentGame else {
            alert("game is nil", handler: { _ in
                self.goHome()
            })
            return
        }
        
        guard let lastTurn = game.turns.last else {
            alert("lastTurn is nil", handler: { _ in
                self.goHome()
            })
            return
        }
        
        guard let imageURL = lastTurn.imageURL() else {
            alert("lastTurn did not have an image", handler: { _ in
                self.goHome()
            })
            return
        }
        imageView.kf.setImage(with: imageURL)
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
                self.startLoading()
                gamesManager.guess(phrase: self.textField.text!, callback: {
                    (error, didFinish) in
                    DispatchQueue.main.async(execute: {
                        self.stopLoading()
                        if let error = error {
                            self.alert("error occured saving guess: \(error.localizedDescription)")
                            return
                        }
                        
                        if (didFinish) {
                            //TODO segue to the completedgame controller
                        }
                        
                        self.goHome()
                    })
                })
            }
        })
        
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        gamesManager.release()//TODO callback
        self.goHome()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from guess View")
            return
        }
        switch segue.identifier! {
        case "flag":
            let controller = segue.destination as! FlagViewController
            controller.game = gamesManager.currentGame?.fragments.gameDetailed
        default:
            NSLog("guess View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
}
