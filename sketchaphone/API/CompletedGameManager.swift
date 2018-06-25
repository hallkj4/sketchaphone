import AWSAppSync

let completedGameManager = CompletedGameManager()

protocol GameWatcher: AnyObject {
    func gamesUpdated()
}

class CompletedGameManager {
    
    public private(set) var inProgressGames = [OpenGameDetailed]()
    
    //    var completedGames = [GameDetailed]()
    //    var completedGamesNextToken: String?
    public private(set) var myCompletedGames = [GameDetailed]()
    
    var myNewlyCompletedGames = Set<String>()
    
    private var refetchTimer: Timer?
    private var myCompletedGamesNextToken: String?
    private var lastTimeIFetchedGames: Date?
    
    
    
    private var watchers = [GameWatcher]()
    func add(watcher: GameWatcher) {
        watchers.append(watcher)
    }
    
    func remove(watcher: GameWatcher) {
        if let index = watchers.index(where: {$0 === watcher}) {
            watchers.remove(at: index)
        }
    }
    
    private func notifyWatchers() {
        for watcher in watchers {
            watcher.gamesUpdated()
        }
    }
    
    func removeFlagged(gameId: String) {
        var removed = false
        if let index = inProgressGames.index(where: {$0.id == gameId}) {
            inProgressGames.remove(at: index)
            removed = true
        }
        if let index = myCompletedGames.index(where: {$0.id == gameId}) {
            myCompletedGames.remove(at: index)
            LocalSQLiteManager.sharedInstance.delete(completedGameId: gameId)
            removeNew(gameId: gameId)
            removed = true
        }
        if (myNewlyCompletedGames.remove(gameId) != nil) {
            LocalSQLiteManager.sharedInstance.delete(newlyCompletedGameId: gameId)
            removed = true
        }
        if (removed) {
            notifyWatchers()
        }
    }
    
    func appendCompleted(game: OpenGameDetailed) {
        if (game.turns.count >= gamesManager.numRounds) {
            myCompletedGames.insert(game.fragments.gameDetailed, at: 0)
        }
        else {
            inProgressGames.append(game)
        }
        notifyWatchers()
    }
    
    func refetchCompletedIfOld(timer: Timer? = nil) {
        if (lastTimeIFetchedGames == nil || lastTimeIFetchedGames! < Date(timeIntervalSinceNow: -60)) {
            self.lastTimeIFetchedGames = Date()
            fetchInProgressGames()
            fetchMyCompletedGames()
        }
    }
    
    func forceRefetch(_ callback: @escaping () -> Void) {
        self.lastTimeIFetchedGames = nil
        fetchMyCompletedGames(callback: callback)
    }
    
    func getCompletedGame(by gameId: String) -> GameDetailed? {
        return myCompletedGames.first(where: {$0.id == gameId})
    }
    
    func isNew(gameId: String) -> Bool {
        return myNewlyCompletedGames.contains(gameId)
    }
    
    func removeNew(gameId: String) {
        if (myNewlyCompletedGames.remove(gameId) != nil) {
            LocalSQLiteManager.sharedInstance.delete(newlyCompletedGameId: gameId)
            DispatchQueue.main.async {
                self.notifyWatchers()
            }
        }
    }
    
    func hasMore() -> Bool {
        return myCompletedGamesNextToken != nil
    }
    
    func getMore() {
        fetchMyCompletedGames(nextPage: true)
    }
    
    private func fetchInProgressGames() {
        NSLog("fetching inprogress games")
        appSyncClient!.fetch(query: InProgressTurnsQuery(), cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let error = error {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            if let error = result?.errors?.first {
                NSLog("Error occurred: \(error.localizedDescription)")
                return
            }
            guard let inProgressTurns = result?.data?.inProgressTurns else {
                NSLog("inprogressTurns was null")
                return
            }
            let games = inProgressTurns.map({$0.game.fragments.openGameDetailed})
            self.inProgressGames = games
            NSLog("got \(self.inProgressGames.count) inProgress games")
            self.notifyWatchers()
        })
    }
    
    private func fetchMyCompletedGames(nextPage: Bool = false, callback: (() -> Void)? = nil) {
        var nextToken: String? = nil
        if (nextPage) {
            nextToken = myCompletedGamesNextToken
        }
        self.myCompletedGamesNextToken = nil
        NSLog("fetching more completed games: \(nextPage)")
        appSyncClient!.fetch(query: MyCompletedTurnsQuery(nextToken: nextToken), cachePolicy: .fetchIgnoringCacheData, resultHandler: { (result, error) in
            if let error = error {
                NSLog("Error occurred: \(error.localizedDescription )")
                callback?()
                return
            }
            if let error = result?.errors?.first {
                NSLog("Error occurred: \(error.localizedDescription )")
                callback?()
                return
            }
            guard let turnsRaw = result?.data?.myCompletedTurns.turns else {
                NSLog("completed turns was null")
                callback?()
                return
            }
            var newFound = false
            NSLog("got " + String(turnsRaw.count) + " completed turns")
            
            let games = turnsRaw.map{$0.game.fragments.gameDetailed}
            for newGame in games {
                if (flagManager.isFlagged(gameId: newGame.id)) {
                    continue
                }
                let new = !self.myCompletedGames.contains(where: { $0.id == newGame.id })
                if (new) {
                    newFound = true
                    if (!nextPage) {
                        self.myNewlyCompletedGames.insert(newGame.id)
                        LocalSQLiteManager.sharedInstance.persist(newlyCompletedGameId: newGame.id)
                        self.myCompletedGames.insert(newGame, at: 0)
                    }
                    else {
                        self.myCompletedGames.append(newGame)
                    }
                    LocalSQLiteManager.sharedInstance.persist(completedGame: newGame)
                }
            }
            self.myCompletedGamesNextToken = result?.data?.myCompletedTurns.nextToken
            
            if (newFound) {
                self.notifyWatchers()
            }
            callback?()
        })
    }
    
    func handleStartUpSignedIn() {
        self.myCompletedGames = LocalSQLiteManager.sharedInstance.getCompletedGames().sorted(by: { g1, g2 -> Bool in
            return Int(g1.turns.last?.createdAt ?? "0") ?? 0 > Int(g2.turns.last?.createdAt ?? "0") ?? 0
        })
        self.myNewlyCompletedGames = LocalSQLiteManager.sharedInstance.getNewlyCompletedGameIds()
        startPeriodicChecks()
    }
    
    func handleSignIn() {
        startPeriodicChecks()
    }
    
    func handleSignOut() {
        stopPeriodicChecks()
        self.lastTimeIFetchedGames = nil
        inProgressGames.removeAll()
        myCompletedGames.removeAll()
        myNewlyCompletedGames.removeAll()
        LocalSQLiteManager.sharedInstance.clearCompletedGames()
        LocalSQLiteManager.sharedInstance.clearNewlyCompletedGames()
        notifyWatchers()
    }
    
    
    private func startPeriodicChecks() {
        self.refetchCompletedIfOld()
        self.refetchTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: self.refetchCompletedIfOld)
    }
    
    private func stopPeriodicChecks() {
        self.refetchTimer?.invalidate()
        self.refetchTimer = nil
    }
}
