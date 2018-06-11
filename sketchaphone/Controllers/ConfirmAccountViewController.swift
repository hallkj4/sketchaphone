import UIKit
class ConfirmAccountViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.emailLabel.text = userManager.getCurrentEmail()
    }
    
    //TODO - use a numberpad instead of normal keybaord
    
    //TODO resend confirmation - see: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/CognitoYourUserPools-Sample/Swift/CognitoYourUserPoolsSample/ConfirmSignUpViewController.swift
    
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
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                userManager.signInExistingCreds(callback: {error, needsConfirm in
                    
                    if let error = error {
                        self.alert(error, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        return
                    }
                    if (needsConfirm) {
                        self.alert("recently confirmed user is not confirmed!? - Please restart the app and try again", handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        return
                    }
                    userManager.setNameExisting(callback: { error in
                        if let error = error {
                            self.alert(error.localizedDescription)
                            self.goHome()
                            return
                        }
                        self.goHome()
                    })
                })
                
                self.alert("Account confirmed! Thanks!", handler: { _ in
                    self.goHome()
                })
            
            }
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
}
