import UIKit
class ConfirmAccountViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.emailLabel.text = userManager.email
    }
    
    @IBAction func confirmTouch() {
        guard let code = codeField.text else {
            alert("Please enter the code from the email you recieved.")
            return
        }
        if (code == "") {
            alert("Please enter the code from the email you recieved.")
            return
        }
        startLoading()
        userManager.confirmAccount(code: code, callback: { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.alert(error)
                }
                return
            }
            self.doSignIn()
        })
    }
    
    @IBAction func resendTouch() {
        startLoading()
        userManager.resendConfirmCode { error in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                self.alert("Confirmation code was resent.")
            }
        }
    }
    
    private func doSignIn() {
        userManager.signInExistingCreds(callback: {error, needsConfirm in
            DispatchQueue.main.async {
                if let error = error {
                    self.stopLoading()
                    self.alert(error, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                if (needsConfirm) {
                    self.stopLoading()
                    self.alert("recently confirmed user is not confirmed!? - Please restart the app and try again", handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.doSetName()
            }
        })
    }
    
    private func doSetName() {
        userManager.setNameExisting(callback: { error in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert("Signed in, but could not set user's name: " + error.localizedDescription, handler: { _ in
                        self.goHome()
                    })
                    return
                }
                self.alert("You're ready to play. Thanks!", title: "Account Confirmed", handler: { _ in
                    self.goHome()
                })
            }
        })
    }
}

extension ConfirmAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmTouch()
        return false
    }
}
