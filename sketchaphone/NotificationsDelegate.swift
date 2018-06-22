import UIKit
import UserNotifications

class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationsDelegate()
    
    private var buffer = [UNNotification]()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            NSLog("the root was not a navigation controller!?")
            completionHandler(.alert)
            return
        }
        guard let topController = rootViewController.topViewController else {
            NSLog("no topViewController")
            completionHandler(.alert)
            return
        }
        let controllerType = type(of: topController)
        if (controllerType == DrawViewController.self || controllerType == GuessViewController.self) {
            buffer.append(notification)
            completionHandler([])
            return
        }
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            NSLog("aps was not a hash?")
            completionHandler()
            return
        }
        guard let gameId = aps["gameId"] as? String else {
            NSLog("game id was not attached to the message")
            completionHandler()
            return
        }
        NSLog("game id found: " + gameId)
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            NSLog("the root was not a navigation controller!?")
            completionHandler()
            return
        }
        guard let topController = rootViewController.topViewController else {
            NSLog("no topViewController")
            completionHandler()
            return
        }
        
        topController.navigateTo(completedGameId: gameId)
        completionHandler()
    }
    
    func pushNotifications() {
        while let notification = buffer.popLast() {
            UNUserNotificationCenter.current().add(notification.request, withCompletionHandler: nil)
        }
    }
}
