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
        //this method will force a sign if if not already signed in
        identityPool?.currentUser()
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
}
