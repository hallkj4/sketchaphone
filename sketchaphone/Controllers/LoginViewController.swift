import UIKit

import AWSCognitoIdentityProvider

class LoginViewController: LoadingViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //TODO: handle user hitting return also
    
    //TODO - use the email keyboard
    
    //TODO - use the remember passwords keyboard thing
    
    @IBAction func loginTouch() {
        startLoading()
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: emailField.text ?? "", password: passwordField.text ?? "")
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
}

extension LoginViewController: AWSCognitoIdentityPasswordAuthentication {

    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        //TODO: update UI with: authenticationInput.lastKnownUsername
    }

    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                self.stopLoading()
                let errorType = error.userInfo["__type"] as? String
                let errorMessage = error.userInfo["message"] as? String
                self.alert((errorType ?? "unknown type") + " " + (errorMessage ?? "no message provided"))
                return
            }
            
            // NO ERROR
            userManager.waitForSignIn {
                self.stopLoading()
                self.emailField?.text = nil
                self.passwordField?.text = nil
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}

