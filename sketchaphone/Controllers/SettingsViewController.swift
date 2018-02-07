import UIKit

class SettingsViewController: LoadingViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        nameField.text = userManager.currentUser?.name
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func nameEditingDone() -> Bool {
        if (nameField.text == nil || nameField.text == "") {
            alert("Name cannot be blank")
            return false
        }
        self.view.endEditing(true)
        userManager.set(name: nameField.text!)
        //TODO callback / loading screen
        return true
    }
}
