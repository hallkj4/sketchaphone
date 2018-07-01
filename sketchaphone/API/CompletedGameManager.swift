import AWSAppSync

let completedGameManager = CompletedGameManager()

protocol GameWatcher: AnyObject {
    func gamesUpdated()
}

class CompletedGameManager {
    
    public private(set) var inProgressGamesCount = 0
    public private(set) var inProgressGames = [OpenGameDetailed]()
    
    //    var completedGames = [GameDetailed]()
    //    var completedGamesNextToken: String?
    public private(set) var myCompletedGames = [GameDetailed]()
    
    var myNewlyCompletedGames = Set<String>()
    
    private var refetchTimer: Timer?
    private var myCompletedGamesNextToken: String?
    private var lastTimeIFetchedGames: Date?
    private var lastTimeIFetchedInProgress: Date?
    
    
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
        var removed = removeInProgress(gameId: gameId)
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
            inProgressGamesCount += 1
            LocalSQLiteManager.sharedInstance.putMisc(key: "inProgressGamesCount", value: String(inProgressGamesCount))
        }
        notifyWatchers()
    }
    
    private func removeInProgress(gameId: String) -> Bool {
        if let index = inProgressGames.index(where: {$0.id == gameId}) {
            inProgressGames.remove(at: index)
            inProgressGamesCount -= 1
            LocalSQLiteManager.sharedInstance.putMisc(key: "inProgressGamesCount", value: String(inProgressGamesCount))
            return true
        }
        return false
    }
    
    func refetchCompletedIfOld(timer: Timer? = nil) {
        if (lastTimeIFetchedGames == nil || lastTimeIFetchedGames! < Date(timeIntervalSinceNow: -60)) {
            self.lastTimeIFetchedGames = Date()
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
    
    func refetchInProgressIfOld(_ callback: @escaping (String?) -> Void) {
        if (lastTimeIFetchedInProgress == nil || lastTimeIFetchedInProgress! < Date(timeIntervalSinceNow: -60)) {
            self.lastTimeIFetchedInProgress = Date()
            fetchInProgressGames(callback)
            return
        }
        callback(nil)
    }
    
    private func fetchInProgressGames(_ callback: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            NSLog("fetching inprogress games")
            appSyncClient!.fetch(query: InProgressTurnsQuery(), cachePolicy: .fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                if let error = error {
                    callback("Error occurred: \(error.localizedDescription )")
                    return
                }
                if let error = result?.errors?.first {
                    callback("Error occurred: \(error.localizedDescription)")
                    return
                }
                guard let inProgressTurns = result?.data?.inProgressTurns else {
                    callback("InprogressTurns was null")
                    return
                }
                let games = inProgressTurns.map({$0.game.fragments.openGameDetailed})
                self.inProgressGames = games
                self.inProgressGamesCount = games.count
                LocalSQLiteManager.sharedInstance.putMisc(key: "inProgressGamesCount", value: String(self.inProgressGamesCount))
                NSLog("got \(self.inProgressGames.count) inProgress games")
                callback(nil)
            })
        }
    }
    
    private func fetchMyCompletedGames(nextPage: Bool = false, callback: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            var nextToken: String? = nil
            if (nextPage) {
                nextToken = self.myCompletedGamesNextToken
            }
            self.myCompletedGamesNextToken = nil
            NSLog("fetching more completed games: \(nextPage)")
            appSyncClient!.fetch(query: MyCompletedTurnsQuery(limit: 5, nextToken: nextToken), cachePolicy: .fetchIgnoringCacheData, queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
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
                        let _ = self.removeInProgress(gameId: newGame.id)
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
    }
    
    func handleStartUpSignedIn() {
        self.myCompletedGames = LocalSQLiteManager.sharedInstance.getCompletedGames().sorted(by: { g1, g2 -> Bool in
            return Int(g1.turns.last?.createdAt ?? "0") ?? 0 > Int(g2.turns.last?.createdAt ?? "0") ?? 0
        })
        self.myNewlyCompletedGames = LocalSQLiteManager.sharedInstance.getNewlyCompletedGameIds()
        self.inProgressGamesCount = Int(LocalSQLiteManager.sharedInstance.getMisc(key: "inProgressGamesCount") ?? "0") ?? 0
        startPeriodicChecks()
    }
    
    func handleSignIn() {
        startPeriodicChecks()
    }
    
    func handleSignOut() {
        stopPeriodicChecks()
        self.lastTimeIFetchedGames = nil
        inProgressGames.removeAll()
        self.inProgressGamesCount = 0
        myCompletedGames.removeAll()
        myNewlyCompletedGames.removeAll()
        LocalSQLiteManager.sharedInstance.clearCompletedGames()
        LocalSQLiteManager.sharedInstance.clearNewlyCompletedGames()
        LocalSQLiteManager.sharedInstance.deleteMisc(key: "inProgressGamesCount")
        notifyWatchers()
    }
    
    func fetchCompletedGame(id: String, callback: @escaping (String?, GameDetailed?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            appSyncClient?.fetch(query: CompletedGameQuery(id: id), queue: DispatchQueue.global(qos: .userInitiated), resultHandler: { (result, error) in
                if let error = error {
                    NSLog("Error occurred: \(error.localizedDescription )")
                    callback(error.localizedDescription, nil)
                    return
                }
                if let error = result?.errors?.first {
                    NSLog("Error occurred: \(error.localizedDescription )")
                    callback(error.localizedDescription, nil)
                    return
                }
                guard let gameRaw = result?.data?.completedGame else {
                    callback(nil, nil)
                    return
                }
                let game = gameRaw.fragments.gameDetailed
                self.myCompletedGames.insert(game, at: 0)
                let _ = self.removeInProgress(gameId: game.id)
                LocalSQLiteManager.sharedInstance.persist(completedGame: game)
                callback(nil, game)
            })
        }
    }
    
    private func startPeriodicChecks() {
        self.refetchCompletedIfOld()
        self.refetchTimer = Timer.scheduledTimer(withTimeInterval: 60.0 * 5, repeats: true, block: self.refetchCompletedIfOld)
    }
    
    private func stopPeriodicChecks() {
        self.refetchTimer?.invalidate()
        self.refetchTimer = nil
    }
}
