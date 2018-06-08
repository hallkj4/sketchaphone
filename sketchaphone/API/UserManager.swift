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
    
    func signedIn() -> Bool {
        return identityPool?.currentUser()?.isSignedIn ?? false
    }
    
    func promptSignIn() {
        NSLog("UserManager.signin invoked")
        //this method will force a sign if if not already signed in
        identityPool?.currentUser()?.getDetails()
    }
    
    func waitForSignIn(_ callback: @escaping () -> Void) {
        if (signedIn()) {
            callback()
            return
        }
        NSLog("not signed in, waiting another second")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.waitForSignIn(callback)
        })
        //TODO - try something liek this instead:
//        identityPool?.currentUser()?.getSession().continueWith(block: { (task) in
//            //blah
//        })
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
    
    func confirmAccount(code: String, callback: @escaping (String?) -> Void) {
        identityPool?.getUser(email!).confirmSignUp(code).continueWith(block: { (task) -> Any? in
            //TODO - set their name!s
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        })
    }
    
    func getCurrentEmail() -> String? {
        return email
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
    
    func signOut() {
        let poolUser = identityPool?.currentUser()
        poolUser?.signOut()
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
    
    func login(email: String, password: String) {
        self.email = email
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email, password: password)
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
    
    func signUp(email: String, password: String, name: String, callback: @escaping (String?, String?) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr!.name = "email"
        emailAttr!.value = email
        attributes.append(emailAttr!)
        self.email = email
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
        DispatchQueue.main.async {
            if let error = error as NSError? {
//                let errorType = error.userInfo["__type"] as? String
                let errorMessage = error.userInfo["message"] as? String
                self.loginDelegate?.handleLoginFailure(message: errorMessage ?? "Unknown error")
                return
            }
            
            // NO ERROR
            userManager.waitForSignIn {
                self.loginDelegate?.handleLogin()
            }
        }
    }
    
}
