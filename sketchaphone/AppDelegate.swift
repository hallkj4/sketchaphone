import UIKit
import GoogleMobileAds
import AWSAppSync
import AWSS3
import AWSCognitoIdentityProvider

var userManager = UserManager()

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

        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoAppId, clientSecret: nil, poolId: CognitoPoolId)
        NSLog("poolConfiguration: %@", poolConfiguration)

        AWSCognitoIdentityUserPool.register(with: configuration, userPoolConfiguration: poolConfiguration, forKey: "UserPool")
        
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        userManager.setPool(pool)
        NSLog("pool: %@", pool)
        NSLog("pool.identityProviderName: %@", pool.identityProviderName)
        
        NSLog("pool?.logins(): %@", pool.logins())
        
        NSLog("cognito pool username: \(pool.currentUser()?.username ?? "unknown")")
        pool.delegate = self
        
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoAWSRegion, identityPoolId: CognitoIdentityPoolId, identityProviderManager: pool)
        userManager.setCredentialsProvider(credentialsProvider)
        NSLog("credentialsProvider: %@", credentialsProvider)
        
        let updatedConfiguration = AWSServiceConfiguration(region: AWSRegion, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = updatedConfiguration
        
        do {
            // Initialize the AWS AppSync configuration
            let appSyncConfig = try AWSAppSyncClientConfiguration(url: AppSyncEndpointURL, serviceRegion: AWSRegion, credentialsProvider: credentialsProvider)
            
            
            // Initialize the AppSync client
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            
            // Set id as the cache key for objects
            appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
        }
        catch {
            NSLog("Error initializing appsync client. Error: %@", error as NSError)
        }
        
        if (userManager.isSignedIn()) {
            flagManager.handleStartUpSignedIn()
            completedGameManager.handleStartUpSignedIn()
        }
        return true
    }
}

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        NSLog("startPasswordAuthentication called")

        DispatchQueue.main.async {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let rootController = self.window?.rootViewController as! UINavigationController
            
            rootController.pushViewController(loginViewController, animated: true)
        }

        return userManager
    }
}

