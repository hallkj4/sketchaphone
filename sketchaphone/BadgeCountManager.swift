import UIKit

class BadgeCountManager: GameWatcher {
    static let shared = BadgeCountManager()
    func gamesUpdated() {
        UIApplication.shared.applicationIconBadgeNumber = completedGameManager.myNewlyCompletedGames.count
    }
}
