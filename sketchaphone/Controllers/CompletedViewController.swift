import UIKit

class CompletedViewController: LoadingViewController, UITableViewDataSource, GameWatcher {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO: pagination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        completedGameManager.add(watcher: self)
        startLoading()
        //TODO - track loading status in the completedGameManager
        completedGameManager.refetchCompleted()
    }
    
    func gamesUpdated() {
        DispatchQueue.main.async {
            self.stopLoading()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedGameManager.completedGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = completedGameManager.completedGameAt(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let firstTurn = game.turns.first
        cell.textLabel!.text = "Game created by \(firstTurn?.user.name ?? "unknown")"
        var detail = "\"" + getPhraseToShow(game: game) + "\""
        
        let completed = game.turns.count >= gamesManager.numRounds
        if (completed) {
            detail += " Completed"
        }
        else {
            detail += " In Progress"
            cell.selectionStyle = .none
        }
        
        if (completedGameManager.isNew(game: game)) {
            detail += " New"
        }
        cell.detailTextLabel!.text = detail
        return cell
    }
    
    private func findMyTurn(_ game: GameDetailed) -> GameDetailed.Turn? {
        return game.turns.first { turn -> Bool in
            return turn.user.id == userManager.currentUser?.id
        }
    }
    
    private func getPhraseToShow(game: GameDetailed) -> String {
        if let myTurn = findMyTurn(game) {
            if let myPhrase = myTurn.phrase {
                return myPhrase
            }
            let previousTurn = game.turns[myTurn.order - 1]
            if let prevPhrase = previousTurn.phrase {
                return prevPhrase
            }
        }
        return game.turns.first?.phrase ?? "unknown"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from completed games view")
            return
        }
        switch segue.identifier! {
        case "details":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                NSLog("completed games: tableView.indexPathForSelectedRow was nil")
                return
            }
            let controller = segue.destination as! CompletedGameViewController
            
            //TODO disallow clicks on uncompleted games
            controller.game = completedGameManager.completedGameAt(indexPath.row)
        default:
            NSLog("completed games controller: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    private func loadUserData() {
        if (!userManager.currentUserFetched()) {
            startLoading()
            userManager.fetchCurrentUser({ error in
                DispatchQueue.main.async {
                    self.stopLoading()
                    if let error = error {
                        self.alert(error)
                        return
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }
}

