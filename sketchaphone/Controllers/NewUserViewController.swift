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
        confirm("Setting name to '\(textField.text!)', are you sure?", confirmedHandler: {
            self.textField.isEnabled = false
            self.startLoading()
            userManager.set(name: self.textField.text!, callback: {(error) in
                DispatchQueue.main.async {
                    self.stopLoading()
                    if let error = error {
                        self.alert("could not set name: \(error.localizedDescription)")
                        return
                    }
                    self.dismiss(animated: true)
                }
            })
        })
    }
}
