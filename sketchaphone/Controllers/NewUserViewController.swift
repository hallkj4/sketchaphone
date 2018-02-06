import UIKit
class NewUserViewController: LoadingViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setName()
        return false
    }
    
    @IBAction func getStartedTouch(_ sender: UIBarButtonItem) {
        setName()
    }
    
    private func setName() {
        if (textField.text == nil || textField.text == "" ) {
            alert("Name cannot be blank")
            return
        }
        confirm("Setting name to '\(textField.text!)', are you sure?", handler: { confirmed in
            if (confirmed) {
                //TODO lock the ui
                self.textField.isEnabled = false
                userManager.set(name: self.textField.text!)
                //TODO - loading animation
                self.dismiss(animated: true) //TODO put this in a callback
                //todo unlock the ui
            }
        })
    }
}
