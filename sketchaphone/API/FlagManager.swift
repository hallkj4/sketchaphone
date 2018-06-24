import Foundation
let flagManager = FlagManager()

class FlagManager {
    private var flaggedGameIds: Set<String> = []
    private var loaded = false
    private var mostRecentCheck: Int?
    private var newMostRecentCheck: Int?
    
    func loadFlags() {
        if (loaded) {
            return
        }
        self.loaded = true
        self.flaggedGameIds = LocalSQLiteManager.sharedInstance.getFlaggedGameIds()
        if let rawRecentCheck = LocalSQLiteManager.sharedInstance.getMisc(key: "mostRecentFlagCheck") {
            self.mostRecentCheck = Int(rawRecentCheck)
        }
        getAllFlags()
    }
    
    func handleStartUpSignedIn() {
        loadFlags()
    }
    
    func handleSignIn() {
        loadFlags()
    }
    
    func handleSignOut() {
        LocalSQLiteManager.sharedInstance.clearFlags()
        LocalSQLiteManager.sharedInstance.deleteMisc(key: "mostRecentFlagCheck")
        flaggedGameIds.removeAll()
        self.mostRecentCheck = nil
        self.loaded = false
    }
    
    func isFlagged(gameId: String) -> Bool {
        return flaggedGameIds.contains(gameId)
    }
    
    private func getAllFlags(token: String? = nil) {
        appSyncClient?.fetch(query: MyFlagsQuery(nextToken: token), cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let error = error {
                NSLog("could not fetch flags, encountered error: " + error.localizedDescription)
                self.loaded = false
                return
            }
            if let error = result?.errors?.first {
                NSLog("could not fetch flags, encountered error: " + error.localizedDescription)
                self.loaded = false
                return
            }
            guard let flags = result?.data?.myFlags.flags else {
                NSLog("there were no flags")
                return
            }
            
            for flag in flags {
                self.addFlaggedGameId(flag.gameId)
                guard let createdAt = Int(flag.createdAt) else {
                    NSLog("error parsing created at on flags: " + flag.createdAt)
                    return
                }
                if (self.newMostRecentCheck == nil) {
                    self.newMostRecentCheck = createdAt
                }
                if (self.mostRecentCheck != nil && createdAt < self.mostRecentCheck!) {
                    self.doneGettingFlags()
                    return
                }
            }
            
            guard let nextToken = result?.data?.myFlags.nextToken else {
                self.doneGettingFlags()
                return
            }
            self.getAllFlags(token: nextToken)
        })
    }
    
    private func doneGettingFlags() {
        NSLog("doneGettingFlags: \(flaggedGameIds.count) flags stored")
        self.mostRecentCheck = newMostRecentCheck
        self.newMostRecentCheck = nil
        if let mostRecentCheck = self.mostRecentCheck {
            LocalSQLiteManager.sharedInstance.putMisc(key: "mostRecentFlagCheck", value: String(mostRecentCheck))
        }
    }
    
    func flag(game: GameDetailed, reason: String, callback: @escaping (Error?) -> Void) {
        appSyncClient?.perform(mutation: FlagGameMutation(gameId: game.id, reason: reason), resultHandler: {(result, error) in
            if let error = error {
                NSLog("Error occurred: \(error.localizedDescription )")
                callback(error)
                return
            }
            if let error = result?.errors?.first {
                NSLog("Error occurred: \(error.localizedDescription )")
                callback(error)
                return
            }
            callback(nil)
            self.addFlaggedGameId(game.id)
        })
    }
    
    private func addFlaggedGameId(_ gameId: String) {
        let insertion = flaggedGameIds.insert(gameId)
        if (insertion.inserted) {
            LocalSQLiteManager.sharedInstance.persist(flaggedGameId: gameId)
        }
        completedGameManager.removeFlagged(gameId: gameId)
    }
}
