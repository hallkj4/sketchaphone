import Foundation
import AWSCognitoIdentityProvider

class UserManager {
    var identityPool: AWSCognitoIdentityUserPool?
    
    //TODO persist this?
    var currentUser: UserBasic?
    
    func setPool(_ identityPool: AWSCognitoIdentityUserPool) {
        self.identityPool = identityPool
    }
    
    func signedIn() -> Bool {
        return identityPool?.currentUser()?.isSignedIn ?? false
    }
    
    func signIn() {
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
        identityPool?.currentUser()?.confirmSignUp(code).continueWith(block: { (task) -> Any? in
            //TODO - set their name!s
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? "unknown error")
                return nil
            }
            callback(nil)
            return nil
        })
    }
    
    func resetPasswordConfirm(code: String, password: String, callback: @escaping (String?) -> Void) {
        identityPool?.currentUser()?.confirmForgotPassword(code, password: password).continueWith(block: { (task) -> Any? in
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
    
    func signUp(email: String, password: String, name: String, callback: @escaping (String?, String?) -> Void) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr!.name = "email"
        emailAttr!.value = email
        attributes.append(emailAttr!)
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
