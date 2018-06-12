import Foundation
import AWSCognitoIdentityProvider

class UserManager : NSObject {
    var identityPool: AWSCognitoIdentityUserPool?
    
    var currentUser: UserBasic?
    var email: String?
    var password: String?
    var name: String?
    
    var loginCallback: ((String?, Bool) -> Void)?
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    func setPool(_ identityPool: AWSCognitoIdentityUserPool) {
        self.identityPool = identityPool
    }
    
    func isSignedIn() -> Bool {
        return identityPool?.currentUser()?.isSignedIn ?? false
    }
    
    func promptSignIn() {
        NSLog("UserManager.signin invoked")
        //this method will force a sign if if not already signed in
        identityPool?.currentUser()?.getDetails()
    }
    
    func waitForSignIn() {
        NSLog("waiting for user to be signed in")
        if (isSignedIn()) {
            self.loginCallback?(nil, false)
            self.loginCallback = nil
            return
        }
        NSLog("not signed in, waiting another second")
        //TODO - this could get stuck...
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.waitForSignIn()
        })
    }
    
    let passwordMessage = "Password must be 8 or more characters."
    
    func validateNewPassword(_ password: String) -> String? {
        if (password.count < 8) {
            return passwordMessage
        }
        return nil
    }
    
    func set(name: String, callback: @escaping (Error?) -> Void) {
        appSyncClient?.perform(mutation: SetNameMutation(name: name), resultHandler: {(result, error) in
            if let error = error {
                callback(error)
                return
            }
            guard let userRaw = result?.data?.setName else {
                callback(NilDataError())
                return
            }
            
            self.currentUser = userRaw.fragments.userBasic
            callback(nil)
        })
    }
    
    func setNameExisting(callback: @escaping (Error?) -> Void) {
        let name = self.name ?? ("Player" + String(arc4random_uniform(9999)))
        set(name: name, callback: callback)
    }
    
    func confirmAccount(code: String, callback: @escaping (String?) -> Void) {
        NSLog("confirming account")
        identityPool?.getUser(email!).confirmSignUp(code).continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                let errorMessage = error.userInfo["message"] as? String ?? "unknown error"
                NSLog("error confirming account: " + errorMessage)
                callback(errorMessage)
                return nil
            }
            
            NSLog("account confirmed successfully")
            callback(nil)
            return nil
        })
    }
    
    func resendConfirmCode(callback: @escaping (String?) -> Void) {
        identityPool?.getUser(email!).resendConfirmationCode().continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        })
    }
    
    func resetPassword(email: String, callback: @escaping (String?) -> Void) {
        let user = identityPool?.getUser(email)
        self.email = email
        user?.forgotPassword().continueWith{(task: AWSTask) -> AnyObject? in
            if let error = task.error as NSError? {
                let message = error.userInfo["message"] as? String
                callback(message ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        }
    }
    
    func resetPasswordConfirm(code: String, password: String, callback: @escaping (String?) -> Void) {
        self.password = password
        identityPool?.getUser(email!).confirmForgotPassword(code, password: password).continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        })
    }
    
    func signIn(email: String, password: String, callback: @escaping (String?, Bool) -> Void) {
        NSLog("signing in")
        self.email = email
        self.password = password
        self.loginCallback = callback
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email, password: password)
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
    
    func signInExistingCreds(callback: @escaping (String?, Bool) -> Void){
        guard let email = self.email else {
            callback("No existing email found.", false)
            return
        }
        
        guard let password = self.password else {
            callback("No existing password found.", false)
            return
        }
        signIn(email: email, password: password, callback: callback)
    }
    
    func signOut() {
        NSLog("signing out")
        let poolUser = identityPool?.currentUser()
        self.email = nil
        self.password = nil
        poolUser?.signOut()
    }
    
    func signUp(email: String, password: String, name: String, callback: @escaping (String?) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr!.name = "email"
        emailAttr!.value = email
        attributes.append(emailAttr!)
        self.email = email
        self.password = password
        self.name = name
        NSLog("signing up")
        identityPool?.signUp(email, password: password, userAttributes: attributes, validationData: nil).continueWith(block: {(task) in
            
            if let error = task.error as NSError? {
                let errorType = (error.userInfo["__type"] as? String) ?? "unknown type"
                NSLog("errortype: " + errorType)
                //TODO if (errorType == "UsernameExistsException") {
                let errorMessage = (error.userInfo["message"] as? String) ?? "unknown error"
                callback(errorMessage)
                return nil
            }
            
            callback(nil)
            return nil
        })
    }
    
    
}


extension UserManager: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        //TODO: update UI with: authenticationInput.lastKnownUsername
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        NSLog("didCompleteStepWithError called")
        if let error = error as NSError? {
            let errorType = (error.userInfo["__type"] as? String) ?? "unknown type"
            NSLog("errortype: " + errorType)
            if errorType == "UserNotConfirmedException" {
                self.loginCallback?(nil, true)
                self.loginCallback = nil
                return
            }
            let errorMessage = (error.userInfo["message"] as? String) ?? "Unknown error"
            self.loginCallback?(errorMessage, false)
            self.loginCallback = nil
            return
        }
        
        waitForSignIn()
    }
    
}
