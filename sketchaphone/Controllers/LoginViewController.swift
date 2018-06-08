import UIKit

import AWSCognitoIdentityProvider

class LoginViewController: LoadingViewController {
    
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var loginDesc: UILabel!
    @IBOutlet weak var signUpDesc: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var switchToLoginButton: UIButton!
    @IBOutlet weak var switchToCreateButton: UIButton!
    
    var showLogin = false
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        showHideUIElements()
    }
    
    func showHideUIElements() {
        nameStack.isHidden = showLogin
        signUpDesc.isHidden = showLogin
        createButton.isHidden = showLogin
        switchToLoginButton.isHidden = showLogin
        
        switchToCreateButton.isHidden = !showLogin
        resetButton.isHidden = !showLogin
        loginDesc.isHidden = !showLogin
        loginButton.isHidden = !showLogin
    }
    
    //TODO: handle user hitting return also
    
    //TODO - use the email keyboard
    
    //TODO - use the remember passwords keyboard thing
    
    @IBAction func loginTouch() {
        startLoading()
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: emailField.text ?? "", password: passwordField.text ?? "")
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
    
    
    @IBAction func getStartedTouch() {
        //TODO check that these are filled
        let email = emailField.text ?? ""
        let password = passwordField.text ?? ""
        let name = nameField.text ?? ""
        startLoading()
        userManager.signUp(email: email, password: password, name: name, callback: {(error, confirmation) in
            
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                if (confirmation != nil) {
                    self.performSegue(withIdentifier: "confirm", sender: nil)
                    return
                }
                NSLog("no confirmation is required")
                
                //TODO - do i need to wait for full sign in?
                self.goHome()
            }
        })
    }
    
    @IBAction func switchTouch() {
        showLogin = !showLogin
        showHideUIElements()
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
                self.nameField?.text = nil
                self.emailField?.text = nil
                self.passwordField?.text = nil
                self.alert("You're signed in", title: "Welcome back!", handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }

}

