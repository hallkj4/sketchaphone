import UIKit

class NewGameViewController: LoadingViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doNew()
        return false
    }
    
    @IBAction func createTouch(_ sender: UIBarButtonItem) {
        doNew()
    }
    
    private func doNew() {
        if (textField.text == nil || textField.text == "") {
            alert("Please enter a word or phrase to start a new game.")
            return
        }
        confirm("Are you sure you want to start a new game with the phrase '\(textField.text!)'", confirmedHandler: {
            self.textField.isEnabled = false
            self.startLoading()
            gamesManager.new(phrase: self.textField.text!, callback: {(error) in
                DispatchQueue.main.async(execute: {
                    self.stopLoading()
                    if let error = error {
                        self.alert("game could not be created: \(error.localizedDescription)")
                        return
                    }
                    self.alert("Your game was created!", title: "Success", handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                })
            })
        })
    }
}
