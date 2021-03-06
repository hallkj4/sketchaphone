import UIKit
import GoogleMobileAds
import AWSAppSync
import AWSS3
import AWSCognitoIdentityProvider
import UserNotifications
import Firebase
import Fabric

var userManager = UserManager()

protocol PushNotificationRegistrationDelegate {
    func didRegisterForPushNotifications(token: String)
    func failedToRegisterForPushNotifications(error: Error)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var storyboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6287206061979264~8980376790")
        inAppPurchaseModel.ready()
        

//        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        let configuration = AWSServiceConfiguration(region: CognitoAWSRegion, credentialsProvider: nil)
        

        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoAppId, clientSecret: nil, poolId: CognitoPoolId)

        AWSCognitoIdentityUserPool.register(with: configuration, userPoolConfiguration: poolConfiguration, forKey: "UserPool")
        
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        userManager.setPool(pool)
        
        pool.delegate = self
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoAWSRegion, identityPoolId: CognitoIdentityPoolId, identityProviderManager: pool)
        userManager.setCredentialsProvider(credentialsProvider)
        
//        NSLog("configuration: %@", configuration ?? "nil")
//        NSLog("poolConfiguration: %@", poolConfiguration)
//        NSLog("pool: %@", pool)
//        NSLog("pool.identityProviderName: %@", pool.identityProviderName)
//        NSLog("pool?.logins(): %@", pool.logins())
//        NSLog("cognito pool username: \(pool.currentUser()?.username ?? "unknown")")
//        NSLog("credentialsProvider: %@", credentialsProvider)
        
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
        UNUserNotificationCenter.current().delegate = NotificationsDelegate.shared
        
        completedGameManager.add(watcher: BadgeCountManager.shared)
        
        if (userManager.isSignedIn()) {
            flagManager.handleStartUpSignedIn()
            completedGameManager.handleStartUpSignedIn()
        }
        userManager.handleStartUp()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        userManager.didRegisterForPushNotifications(token: token)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        userManager.failedToRegisterForPushNotifications(error: error)
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

