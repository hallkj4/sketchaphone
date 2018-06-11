import UIKit
class ConfirmAccountViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.emailLabel.text = userManager.getCurrentEmail()
        userManager.loginDelegate = self
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
        userManager.confirmAccount(code: code)
    }
}

extension ConfirmAccountViewController: LoginDelegate {
    
    func handleLogin() {
        DispatchQueue.main.async {
            self.stopLoading()
            self.alert("Account confirmed! Thanks!", handler: { _ in
                self.goHome()
            })
        }
    }
    
    func handleLoginFailure(message: String) {
        DispatchQueue.main.async {
            self.stopLoading()
            self.alert(message)
        }
    }
    
}
