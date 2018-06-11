import UIKit
class ResetPasswordConfirmViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    //TODO - use a numberpad instead of normal keybaord
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //TODO resend confirmation - see: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/CognitoYourUserPools-Sample/Swift/CognitoYourUserPoolsSample/ConfirmSignUpViewController.swift
    
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
            alert("Please enter the code from the email you recieved.")
            return
        }
        if (password == "") {
            alert("Please enter the code from the email you recieved.")
            return
        }
        startLoading()
        userManager.resetPasswordConfirm(code: code, password: password) { (error) in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                self.alert("Password reset successfully!", handler: { _ in
                    self.goHome()
                })
                
            }
        }
    }
}
