import UIKit

import AWSCognitoIdentityProvider

class LoginViewController: LoadingViewController, LoginDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.loginDelegate = self
    }
    
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
        
        guard let email = emailField.text else {
            alert("Email is required.")
            return
        }
        if (email == "") {
            alert("Email is required.")
            return
        }
        guard let password = passwordField.text else {
            alert("A password of 6 or more characters is required.")
            return
        }
        if (password.count < 6) {
            alert("A password of 6 or more characters is required.")
            return
        }
        startLoading()
        
        userManager.login(email: email, password: password)
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
            alert("A password of 6 or more characters is required.")
            return
        }
        if (password.count < 6) {
            alert("A password of 6 or more characters is required.")
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

    func handleLogin() {
        stopLoading()
        self.nameField?.text = nil
        self.emailField?.text = nil
        self.passwordField?.text = nil
        self.alert("You're signed in", title: "Welcome back!", handler: { _ in
            self.goHome()
        })
    }
    
    func handleLoginFailure(message: String) {
        stopLoading()
        alert(message)
    }
    
}

