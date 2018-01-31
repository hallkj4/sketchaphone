import UIKit

class NewGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    let defaultText = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = defaultText
        textField.textColor = .gray
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == defaultText) {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doNew()
        return false
    }
    
    @IBAction func createTouch(_ sender: UIBarButtonItem) {
        doNew()
    }
    
    private func doNew() {
        if (textField.text == nil || textField.text == "" || textField.text == defaultText) {
            alert("Please enter a word or phrase to start a new game.")
            return
        }
        confirm("Are you sure you want to start a new game with the phrase '\(textField.text!)'", handler: { confirmed in
            if (confirmed) {
                self.textField.isEnabled = false
                gamesManager.new(phrase: self.textField.text!)
                //TODO - loading animation
                self.dismiss(animated: true) //TODO put this in a callback
            }
        })
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
