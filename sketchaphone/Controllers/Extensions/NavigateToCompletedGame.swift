import UIKit

protocol NavigateToCompletedGame {
    func navigateTo(completedGame: GameDetailed)
}

extension UIViewController: NavigateToCompletedGame {
    func navigateTo(completedGame: GameDetailed) {
        guard let rootController = self.navigationController?.viewControllers[0] else {
            NSLog("Could not get root view controller")
            return
        }
        guard let completedViewController = self.storyboard?.instantiateViewController(withIdentifier: "CompletedViewController") else {
            NSLog("could not instantiate CompletedViewController")
            return
        }
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CompletedGameViewController") else {
            NSLog("could not instantiate CompletedGameViewController")
            return
        }
        guard let completedGameViewController = controller as? CompletedGameViewController else {
            NSLog("could not cast CompletedViewController")
            return
        }
        completedGameViewController.game = completedGame
        self.navigationController?.setViewControllers([rootController, completedViewController, completedGameViewController], animated: true)
    }
}
