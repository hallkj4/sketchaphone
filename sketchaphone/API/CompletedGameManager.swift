import AWSAppSync

let completedGameManager = CompletedGameManager()

protocol GameWatcher: AnyObject {
    func gamesUpdated()
}

class CompletedGameManager {
    
    var inProgressGames = [OpenGameDetailed]()
    
    //    var completedGames = [GameDetailed]()
    //    var completedGamesNextToken: String?
    var myCompletedGames = [GameDetailed]()
    
    var myNewlyCompletedGames = [GameDetailed]()
    
    var myCompletedGamesNextToken: String?
    
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
    
    func removeFlagged(game: GameDetailed) {
        var removed = false
        if let index = inProgressGames.index(where: {$0.id == game.id}) {
            inProgressGames.remove(at: index)
            removed = true
        }
        if let index = myCompletedGames.index(where: {$0.id == game.id}) {
            myCompletedGames.remove(at: index)
            removed = true
        }
        if (removed) {
            notifyWatchers()
        }
    }
    
    func appendCompleted(game: OpenGameDetailed) {
        if (game.turns.count >= gamesManager.numRounds) {
            myCompletedGames.append(game.fragments.gameDetailed)
            myNewlyCompletedGames.append(game.fragments.gameDetailed)
        }
        else {
            inProgressGames.append(game)
        }
        notifyWatchers()
    }
    private var lastTimeIFetchedGames: Date?
    func refetchCompletedIfOld() {
        if (lastTimeIFetchedGames == nil || lastTimeIFetchedGames! < Date(timeIntervalSinceNow: -60)) {
            lastTimeIFetchedGames = Date()
            fetchInProgressGames()
            fetchMyCompletedGames()
        }
    }
    
    func completedGameCount() -> Int {
        return inProgressGames.count + myCompletedGames.count
    }
    
    func completedGameAt(_ i: Int) -> GameDetailed {
        if (i < inProgressGames.count) {
            return inProgressGames[i].fragments.gameDetailed
        }
        return myCompletedGames[i - inProgressGames.count]
    }
    
    func isNew(game: GameDetailed) -> Bool {
        return myNewlyCompletedGames.contains(where: { g -> Bool in
            return game.id == g.id
        })
    }
    
    func removeNew(game: GameDetailed) {
        if let i = myNewlyCompletedGames.index(where: { g -> Bool in
            return g.id == game.id
        }) {
            myNewlyCompletedGames.remove(at: i)
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
    
    func handleSignOut() {
        inProgressGames.removeAll()
        myCompletedGames.removeAll()
        myNewlyCompletedGames.removeAll()
    }
    
    private func fetchInProgressGames() {
        NSLog("fetching inprogress games")
        appSyncClient!.fetch(query: InProgressTurnsQuery(), resultHandler: { (result, error) in
            if let error = error {
                print("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let inProgressTurns = result?.data?.inProgressTurns else {
                NSLog("inprogressTurns was null")
                return
            }
            self.inProgressGames = inProgressTurns.map({$0.game.fragments.openGameDetailed})
            NSLog("got \(self.inProgressGames.count) inProgress games")
            self.notifyWatchers()
        })
    }
    
    private func fetchMyCompletedGames(nextPage: Bool = false) {
        var nextToken: String? = nil
        if (nextPage) {
            nextToken = myCompletedGamesNextToken
        }
        myCompletedGamesNextToken = nil
        
        appSyncClient!.fetch(query: MyCompletedTurnsQuery(nextToken: nextToken) , resultHandler: { (result, error) in
            if let error = error {
                NSLog("Error occurred: \(error.localizedDescription )")
                return
            }
            guard let turnsRaw = result?.data?.myCompletedTurns.turns else {
                NSLog("completed turns was null")
                return
            }
            var newFound = false
            NSLog("got " + String(turnsRaw.count) + " completed turns")
            
            let games = turnsRaw.map{$0.game.fragments.gameDetailed}
            games.forEach({ newGame in
                let new = !self.myCompletedGames.contains(where: { game -> Bool in
                    return game.id == newGame.id
                })
                if (new) {
                    if (!nextPage) {
                        newFound = true
                        self.myNewlyCompletedGames.append(newGame)
                    }
                    self.myCompletedGames.append(newGame)
                }
            })
            self.myCompletedGamesNextToken = result?.data?.myCompletedTurns.nextToken
            
            if (newFound) {
                self.notifyWatchers()
            }
        })
    }
    
    //    func fetchAllCompletedGames(nextPage: Bool = false) {
    //        var nextToken: String? = nil
    //        if (nextPage) {
    //            nextToken = completedGamesNextToken
    //        }
    //        else {
    //            completedGames.removeAll()
    //        }
    //        completedGamesNextToken = nil
    //
    //        appSyncClient!.fetch(query: CompletedGamesQuery(nextToken: nextToken), resultHandler: { (result, error) in
    //            if let error = error {
    //                print("Error occurred: \(error.localizedDescription )")
    //                return
    //            }
    //            guard let gamesRaw = result?.data?.completedGames.games else {
    //                NSLog("completed games was null")
    //                return
    //            }
    //            self.completedGames = gamesRaw.map{$0.fragments.gameDetailed}
    //            self.completedGamesNextToken = result?.data?.completedGames.nextToken
    //
    //            self.notifyWatchers()
    //        })
    //    }
    
}
