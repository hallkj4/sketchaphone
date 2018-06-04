import UIKit

import AWSCognitoIdentityProvider

class LoginViewController: LoadingViewController {
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    
    @IBAction func loginTouch() {
        startLoading()
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: "michaeleconomy@gmail.com", password: "sketchyphone1")
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
//                    self.usernameInput?.text = nil
//                    self.passwordInput?.text = nil
                })
            }
        }
    }

}

