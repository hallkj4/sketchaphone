import UIKit
class ResetPasswordConfirmViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func resendTouch() {
        startLoading()
        userManager.resendResetPassword { error in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                self.alert("Password reset email resent!")
            }
            
        }
    }
    
    @IBAction func resetPasswordTouch() {
        guard let code = codeField.text else {
            alert("Please enter the code from the email you recieved.")
            return
        }
        if (code == "") {
            alert("Please enter the code from the email you recieved.")
            return
        }
        
        guard let password = passwordField.text else {
            alert(userManager.passwordMessage)
            return
        }
        if let error = userManager.validateNewPassword(password) {
            alert(error)
            return
        }
        startLoading()
        userManager.resetPasswordConfirm(code: code, password: password) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.alert(error)
                    return
                }
            }
            DispatchQueue.main.async {
                self.codeField.text = nil
                self.passwordField.text = nil
            }
            self.doSignIn()
        }
    }
    
    private func doSignIn() {
        userManager.signInExistingCreds(callback: { (error, needsConfirm) in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert("Your password has been reset, but there was an error logging you in: " + error, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                if (needsConfirm) {
                    self.alert("Email Confirmation - unknown error", handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    return
                }
                self.alert("Your password has been reset and you have been signed in.", title: "Success", handler: {_ in
                    self.goHome()
                })
            }
        })
    }
}

extension ResetPasswordConfirmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPasswordTouch()
        return false
    }
}

