import Foundation
import AWSCognitoIdentityProvider

protocol LoginDelegate {
    func handleLogin()
    func handleLoginFailure(message: String)
}

class UserManager : NSObject {
    var identityPool: AWSCognitoIdentityUserPool?
    
    //TODO persist this?
    var currentUser: UserBasic?
    var email: String?
    var password: String?
    
    var loginDelegate: LoginDelegate?
    
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
            self.loginDelegate?.handleLogin()
            return
        }
        NSLog("not signed in, waiting another second")
        //TODO - this could get stuck...
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.waitForSignIn()
        })
    }
    
    
    func getCurrentEmail() -> String? {
        return email
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
    
    func confirmAccount(code: String) {
        NSLog("confirming account")
        identityPool?.getUser(email!).confirmSignUp(code).continueWith(block: { (task) -> Any? in
            //TODO - set their name!s
            if let error = task.error as NSError? {
                let errorMessage = error.userInfo["message"] as? String ?? "unknown error"
                NSLog("error confirming account: " + errorMessage)
                self.loginDelegate?.handleLoginFailure(message: errorMessage)
                return nil
            }
            
            NSLog("account confirmed successfully")
            guard let email = self.email else {
                self.loginDelegate?.handleLoginFailure(message: "Confirmation successful. No saved email found, please login.")
                return nil
            }
            
            guard let password = self.password else {
                self.loginDelegate?.handleLoginFailure(message: "Confirmation successful. No saved password found, please login.")
                return nil
            }
            self.signIn(email: email, password: password)
            return nil
        })
    }
    
    func resetPasswordConfirm(code: String, password: String, callback: @escaping (String?) -> Void) {
        identityPool?.getUser(email!).confirmForgotPassword(code, password: password).continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        })
    }
    
    func signIn(email: String, password: String) {
        NSLog("signing in")
        self.email = email
        self.password = password
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email, password: password)
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
    
    func signOut() {
        NSLog("signing out")
        let poolUser = identityPool?.currentUser()
        self.email = nil
        self.password = nil
        poolUser?.signOut()
    }
    
    func signUp(email: String, password: String, name: String, callback: @escaping (String?, String?) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr!.name = "email"
        emailAttr!.value = email
        attributes.append(emailAttr!)
        self.email = email
        self.password = password
        NSLog("signing up")
        identityPool?.signUp(email, password: password, userAttributes: attributes, validationData: nil).continueWith(block: {(task) in
            
            if let error = task.error as NSError? {
                callback((error.userInfo["message"] as? String) ?? "unknown error", nil)
                return nil
            }
            guard let result = task.result else {
                callback("task result was not set, and error wasn't set", nil)
                return nil
            }
            // handle the case where user has to confirm his identity via email / SMS
            if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                let confirmAddress = (result.codeDeliveryDetails?.destination ?? "unknown")
                NSLog("confirmation required: confirmation delivered to: " + confirmAddress)
                callback(nil, confirmAddress)
                return nil
            }
            callback(nil, nil)
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
//                let errorType = error.userInfo["__type"] as? String
            let errorMessage = error.userInfo["message"] as? String
            self.loginDelegate?.handleLoginFailure(message: errorMessage ?? "Unknown error")
            return
        }
        
        waitForSignIn()
    }
    
}
