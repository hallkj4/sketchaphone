import UIKit
class ConfirmAccountViewController: LoadingViewController {
    @IBOutlet weak var codeField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
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
        userManager.confirmAccount(code: code) { (error) in
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                self.alert("Account confirmed! Thanks!", handler: { _ in
                    self.goHome()
                })
                
            }
        }
    }
}
