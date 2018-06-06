import UIKit

import AWSCognitoIdentityProvider

class LoginViewController: LoadingViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    
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
            self.stopLoading()
            if let error = error as NSError? {
                self.alert(error.localizedDescription)
            }
            else {
                NSLog("success??")
                self.dismiss(animated: true, completion: {
                    //TODO
//                    self.usernameInput?.text = nil
//                    self.passwordInput?.text = nil
                })
            }
        }
    }

}

