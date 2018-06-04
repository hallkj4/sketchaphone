import UIKit
import GoogleMobileAds
import AWSAppSync
import AWSS3
//import AWSUserPoolsSignIn
//import AWSAuthUI
import AWSCognitoIdentityProvider

var credentialsProvider: AWSCognitoCredentialsProvider?
var pool: AWSCognitoIdentityUserPool?

//class KeyProvider: AWSAPIKeyAuthProvider {
//    func getAPIKey() -> String {
//        return "da2-jhecjzi5ercorfoitswuscbate"
//    }
//}
//var apiKeyAuthProvider = KeyProvider()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6287206061979264~8980376790")
        inAppPurchaseModel.ready()
        

        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        let configuration = AWSServiceConfiguration(region: CognitoAWSRegion, credentialsProvider: nil)
        NSLog("configuration: %@", configuration ?? "nil")

        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoAppId, clientSecret: CognitoAppClientSecret, poolId: CognitoPoolId)
        NSLog("poolConfiguration: %@", poolConfiguration)

        AWSCognitoIdentityUserPool.register(with: configuration, userPoolConfiguration: poolConfiguration, forKey: "UserPool")
        
        pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        NSLog("pool: %@", pool ?? "nil")
        NSLog("pool.identityProviderName: %@", pool?.identityProviderName ?? "nil")
        
        NSLog("pool?.logins(): %@", pool?.logins() ?? "nil")
        
        NSLog("cognito pool username: \(pool?.currentUser()?.username ?? "unknown")")
        pool!.delegate = self
        
        
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoAWSRegion, identityPoolId: CognitoIdentityPoolId, identityProviderManager: pool!)
        NSLog("credentialsProvider: %@", credentialsProvider ?? "nil")
        
//        AWSCognitoUserPoolsSignInProvider.setupUserPool(withId: CognitoIdentityPoolId, cognitoIdentityUserPoolAppClientId: CognitoAppId, cognitoIdentityUserPoolAppClientSecret: "", region: AWSRegion)
//        let pool = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool()
//
//        AWSSignInManager.sharedInstance().register(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())
//
//        let helper = AWSCognitoCredentialsProviderHelper(regionType: AWSRegion, identityPoolId: CognitoIdentityPoolId, useEnhancedFlow: false, identityProviderManager: pool)
//
//        credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegion, identityProvider: helper)


//        let updatedConfiguration = AWSServiceConfiguration(region: AWSRegion, credentialsProvider: credentialsProvider!)
        
        
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
//        credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegion, identityPoolId: "us-west-2:949ac5f7-a5ed-4a1f-975c-bfff3f9a571b")
//
        
        let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(database_name)
        
        do {
            // Initialize the AWS AppSync configuration
            let appSyncConfig = try AWSAppSyncClientConfiguration(url: AppSyncEndpointURL, serviceRegion: AWSRegion,
                                                                  credentialsProvider: credentialsProvider!,
                                                                  databaseURL:databaseURL)
            
            // Initialize the AppSync client
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            
            // Set id as the cache key for objects
            appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
        }
        catch {
            NSLog("Error initializing appsync client. Error: %@", error as NSError)
        }
        
        appSyncClient?.fetch(query: OpenGamesQuery(), resultHandler: {(results, error) in
            NSLog("error: %@", error as NSError? ?? "nil")
        })
        
        return true
    }

}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {

    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        let tabController = self.window?.rootViewController as! UITabBarController


        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

//        DispatchQueue.main.async {
//            self.navigationController?.present(loginViewController!, animated: true, completion: nil)
//        }

//        let newGamesNavController = tabController.selectedViewController as! UINavigationController
//        newGamesNavController.topViewController!.performSegue(withIdentifier: "login", sender: self)
        DispatchQueue.main.async {
            tabController.present(loginViewController, animated: true, completion: nil)
        }

        return loginViewController
    }
}

