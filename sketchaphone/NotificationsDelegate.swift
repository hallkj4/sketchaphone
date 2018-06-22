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
    
    func pushNotifications() {
        while let notification = buffer.popLast() {
            UNUserNotificationCenter.current().add(notification.request, withCompletionHandler: nil)
        }
    }
}
