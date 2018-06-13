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
    
    @IBAction func loginTouch() {
        guard let email = emailField.text else {
            alert("Email is required.")
            return
        }
        if (email == "") {
            alert("Email is required.")
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
        
        userManager.signIn(email: email, password: password, callback: handleSignIn)
    }
    
    
    @IBAction func getStartedTouch() {
        guard let email = emailField.text else {
            alert("Email is required.")
            return
        }
        if (email == "") {
            alert("Email is required.")
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
        guard let name = nameField.text else {
            alert("Name is required.")
            return
        }
        if (name == "") {
            alert("Name is required.")
            return
        }
        startLoading()
        userManager.signUp(email: email, password: password, name: name, callback: {(error, accountExists) in
            
            DispatchQueue.main.async {
                self.stopLoading()
                if let error = error {
                    self.alert(error)
                    return
                }
                if (accountExists) {
                    self.alert("That account already exisits. Attempting to sign you in.", handler: { _ in
                        self.showLogin = true
                        self.showHideUIElements()
                        userManager.signInExistingCreds(callback: self.handleSignIn)
                    })
                    return
                }
                self.performSegue(withIdentifier: "confirm", sender: nil)
            }
        })
    }
    
    @IBAction func switchTouch() {
        showLogin = !showLogin
        showHideUIElements()
    }

    private func handleSignIn(error: String?, needsConfirm: Bool) {
        DispatchQueue.main.async {
            if let error = error {
                self.stopLoading()
                self.alert(error)
                return
            }
            if (needsConfirm) {
                self.stopLoading()
                self.performSegue(withIdentifier: "confirm", sender: nil)
                return
            }
            self.stopLoading()
            self.alert("You are signed in.", title: "Welcome back!", handler: { _ in
                self.nameField?.text = nil
                self.emailField?.text = nil
                self.passwordField?.text = nil
                self.goHome()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from draw View")
            return
        }
        switch segue.identifier! {
        case "resetPass":
            userManager.email = emailField.text
        default:
            NSLog("draw View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (showLogin) {
            loginTouch()
        }
        else {
            getStartedTouch()
        }
        return false
    }
}
