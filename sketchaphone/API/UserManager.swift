import AWSCognitoIdentityProvider
import AWSAppSync
import UserNotifications
import Firebase

class UserManager: NSObject {
    var identityPool: AWSCognitoIdentityUserPool?
    var credentialsProvider: AWSCognitoCredentialsProvider?
    
    public private(set) var currentUser: UserBasic?
    var email: String?
    private var password: String?
    private var name: String?
    
    public private(set) var pushEnabled = false
    private var shouldPromptForPush = false
    
    private var loginCallback: ((String?, Bool) -> Void)?
    private var enablePushCallback: ((String?) -> Void)?
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    func setPool(_ identityPool: AWSCognitoIdentityUserPool) {
        self.identityPool = identityPool
    }
    
    func setCredentialsProvider(_ credentialsProvider: AWSCognitoCredentialsProvider) {
        self.credentialsProvider = credentialsProvider
    }
    
    func isSignedIn() -> Bool {
        return identityPool?.currentUser()?.isSignedIn ?? false
    }
    
    func currentUserFetched() -> Bool {
        return currentUser != nil
    }
    
    func fetchCurrentUser(_ callback: @escaping (String?) -> Void) {
        appSyncClient?.fetch(query: CurrentUserQuery(), cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let error = error {
                callback(error.localizedDescription)
                return
            }
            guard let userRaw = result?.data?.currentUser else {
                callback("Current user was not returned.")
                return
            }
            self.currentUser = userRaw.fragments.userBasic
            Analytics.setUserID(self.currentUser!.id)
            callback(nil)
        })
    }
    
    func promptSignIn() {
        NSLog("UserManager.signin invoked")
        //this method will force a sign if if not already signed in
        identityPool?.currentUser()?.getDetails()
    }
    
    func waitForSignIn() {
        NSLog("waiting for user to be signed in")
        if (isSignedIn()) {
            completeSignIn()
            
            self.loginCallback?(nil, false)
            self.loginCallback = nil
            return
        }
        NSLog("not signed in, waiting another second")
        //Note - this could get stuck...
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
    
    
    func set(deviceToken: String?, callback: @escaping (Error?) -> Void) {
        if (networkOffline()) {
            callback(NoNetworkError())
            return
        }
        appSyncClient?.perform(mutation: SetDeviceTokenMutation(token: deviceToken), resultHandler: {(result, error) in
            if let error = error {
                callback(error)
                return
            }
            if (result?.data?.setDeviceToken != true) {
                callback(NilDataError())
                return
            }
            
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
                let errorMessage = error.userInfo["message"] as? String ?? error.localizedDescription
                NSLog("error confirming account: " + errorMessage)
                callback(errorMessage)
                return nil
            }
            
            NSLog("account confirmed successfully")
            self.handleSignUp()
            callback(nil)
            return nil
        })
    }
    
    func resendConfirmCode(callback: @escaping (String?) -> Void) {
        identityPool?.getUser(email!).resendConfirmationCode().continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                callback(error.userInfo["message"] as? String ?? error.localizedDescription)
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
                let errorType = (error.userInfo["__type"] as? String) ?? "unknown type"
                var errorMessage = (error.userInfo["message"] as? String) ?? error.localizedDescription
                if (errorType == "InvalidParameterException") {
                    errorMessage = "Email address is invalid"
                }
                callback(errorMessage)
                return nil
            }
            callback(nil)
            return nil
        }
    }
    
    func resendResetPassword(_ callback: @escaping (String?) -> Void) {
        guard let email = self.email else {
            callback("Email was lost - please click 'back' to reset password.")
            return
        }
        resetPassword(email: email, callback: callback)
    }
    
    func resetPasswordConfirm(code: String, password: String, callback: @escaping (String?) -> Void) {
        self.password = password
        identityPool?.getUser(email!).confirmForgotPassword(code, password: password).continueWith(block: { (task) -> Any? in
            if let error = task.error as NSError? {
                let errorMessage = (error.userInfo["message"] as? String) ?? error.localizedDescription
                callback(errorMessage)
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
    
    func signOut(_ callback: @escaping (String?) -> Void) {
        NSLog("signing out")
        if (!pushEnabled) {
            completeSignOut()
            callback(nil)
            return
        }
        set(deviceToken: nil, callback: { error in
            if let error = error {
                callback(error.localizedDescription)
                return
            }
            self.completeSignOut()
            callback(nil)
        })
    }

    private func completeSignOut() {
        self.email = nil
        self.password = nil
        self.name = nil
        self.currentUser = nil
        self.pushEnabled = false
        LocalSQLiteManager.sharedInstance.deleteMisc(key: "pushEnabled")
        completedGameManager.handleSignOut()
        gamesManager.handleSignOut()
        flagManager.handleSignOut()
        Analytics.logEvent("sign_out", parameters: nil)
        Analytics.setUserID(nil)
        identityPool?.clearAll()
        credentialsProvider?.clearKeychain()
    }
    
    private func completeSignIn() {
        Analytics.logEvent("sign_in", parameters: nil)
        completedGameManager.handleSignIn()
        flagManager.handleSignIn()
        getNotificationSettings()
    }
    
    func handleStartUp() {
        self.pushEnabled = LocalSQLiteManager.sharedInstance.getMisc(key: "pushEnabled") != nil
        self.shouldPromptForPush = LocalSQLiteManager.sharedInstance.getMisc(key: "shouldPromptForPush") != nil
        getNotificationSettings()
    }
    
    private func handleSignUp() {
        getNotificationSettings()
        Analytics.logEvent("sign_up", parameters: nil)
        if (!pushEnabled) {
            self.shouldPromptForPush = true
            LocalSQLiteManager.sharedInstance.putMisc(key: "shouldPromptForPush", value: "true")
        }
        
    }
    
    func conditionallyPromptForPush(_ callback: @escaping (String?) -> Void) {
        if(pushEnabled) {
            callback(nil)
            return
        }
        if(!shouldPromptForPush) {
            callback(nil)
            return
        }
        self.shouldPromptForPush = false
        LocalSQLiteManager.sharedInstance.deleteMisc(key: "shouldPromptForPush")
        enablePushNotifications(callback)
    }
    
    func enablePushNotifications(_ callback: @escaping (String?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, err) in
            if let err = err {
                callback(err.localizedDescription)
                return
            }
            NSLog("Permission granted: \(granted)")
            
            guard granted else { return }
            self.enablePushCallback = callback
            self.getNotificationSettings()
        }
    }
    
    func disablePushNotifications(_ callback: ((String?) -> Void)? = nil) {
        self.set(deviceToken: nil) { err in
            if let err = err {
                NSLog("error setting device token: " + err.localizedDescription)
                callback?(err.localizedDescription)
                return
            }
            UIApplication.shared.unregisterForRemoteNotifications()
            LocalSQLiteManager.sharedInstance.deleteMisc(key: "pushEnabled")
            self.pushEnabled = false
            callback?(nil)
        }
    }
    
    private func getNotificationSettings() {
        if (!isSignedIn()) {
            return
        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            if settings.authorizationStatus == .authorized {
                if (!self.pushEnabled) {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
            else {
                if (self.pushEnabled) {
                    self.disablePushNotifications()
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, callback: @escaping (String?, Bool) -> Void) {
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
                if (errorType == "UsernameExistsException") {
                    callback(nil, true)
                }
                var errorMessage = (error.userInfo["message"] as? String) ?? error.localizedDescription
                if (errorType == "InvalidParameterException") {
                    errorMessage = "Email address is invalid"
                }
                callback(errorMessage, false)
                return nil
            }
            
            callback(nil, false)
            return nil
        })
    }
}

extension UserManager: AWSCognitoIdentityPasswordAuthentication {
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        NSLog("didCompleteStepWithError called")
        if let error = error as NSError? {
            let errorType = (error.userInfo["__type"] as? String) ?? "unknown type"
            NSLog("errortype: " + errorType)
            if (errorType == "UserNotConfirmedException") {
                self.loginCallback?(nil, true)
                self.loginCallback = nil
                return
            }
            var errorMessage = (error.userInfo["message"] as? String) ?? error.localizedDescription
            
            if (errorType == "InvalidParameterException") {
                errorMessage = "Email address is invalid"
            }
            self.loginCallback?(errorMessage, false)
            self.loginCallback = nil
            return
        }
        
        waitForSignIn()
    }
}

extension UserManager: PushNotificationRegistrationDelegate {
    func didRegisterForPushNotifications(token: String) {
        if (!isSignedIn()) {
            NSLog("can't do this while signed out")
            return
        }
        set(deviceToken: token) { err in
            if let err = err {
                NSLog("error setting deviceToken: " + err.localizedDescription)
                self.enablePushCallback?(err.localizedDescription)
                return
            }
            self.pushEnabled = true
            LocalSQLiteManager.sharedInstance.putMisc(key: "pushEnabled", value: "true")
            Analytics.logEvent("enabled_push", parameters: nil)
            self.enablePushCallback?(nil)
        }
    }
    
    func failedToRegisterForPushNotifications(error: Error) {
        NSLog("failedToRegisterForPushNotifications: " + error.localizedDescription)
        enablePushCallback?(error.localizedDescription)
    }
}
