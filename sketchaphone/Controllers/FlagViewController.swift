import UIKit
class FlagViewController: LoadingViewController {
    var game: GameDetailed?
    var turn: GameDetailed.Turn?
    
    @IBOutlet weak var textField: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    @IBAction func flagTouch(_ sender: UIBarButtonItem) {
        if (textField.text == nil || textField.text == "") {
            alert("Reason cannot be blank.")
            return
        }
        startLoading()
        if (gamesManager.currentGame != nil) {
            gamesManager.release()
        }
        gamesManager.flag(game: game!, reason: textField.text, callback: {(error) in
            DispatchQueue.main.async(execute: {
                self.stopLoading()
                if let error = error {
                    self.alert("Error occurred: \(error.localizedDescription)")
                    return
                }
                self.goHome()
            })
        })
    }
}

