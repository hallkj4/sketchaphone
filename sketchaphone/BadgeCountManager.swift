import UIKit

class BadgeCountManager: GameWatcher {
    static let shared = BadgeCountManager()
    func gamesUpdated() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = completedGameManager.myNewlyCompletedGames.count
        }
    }
}
