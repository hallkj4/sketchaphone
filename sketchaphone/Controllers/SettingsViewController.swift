import UIKit
import StoreKit

class SettingsViewController: LoadingViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameField.text = userManager.currentUser?.name
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        startLoading()
        userManager.set(name: nameField.text!, callback: {(error) in
            self.stopLoading()
            if let error = error {
                self.alert("Error setting name, please edit to try again: \(error.localizedDescription)")
            }
        })
        return true
    }
    
    @IBAction func signOutTouch() {
        confirm("Are you sure you want to sign out?", confirmedHandler: {
            userManager.signOut()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
