import UIKit

class CompletedViewController: LoadingViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGamesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        completedGameManager.add(watcher: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completedGameManager.remove(watcher: self)
    }
    
    private func updateUI() {
        tableView.reloadData()
        noGamesLabel.isHidden = 
            !completedGameManager.myCompletedGames.isEmpty || !completedGameManager.inProgressGames.isEmpty
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (completedGameManager.hasMore() && completedGameManager.myCompletedGames.count == 0) {
            completedGameManager.getMore()
        }
        var count = completedGameManager.myCompletedGames.count
        if (!completedGameManager.inProgressGames.isEmpty) {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (completedGameManager.hasMore() && indexPath.row >= completedGameManager.myCompletedGames.count) {
            completedGameManager.getMore()
        }
        if (indexPath.row == 0 && !completedGameManager.inProgressGames.isEmpty) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inProgressCell", for: indexPath)
            guard let gamesCell = cell as? InProgressGamesTableViewCell else {
                NSLog("cell was not type: InProgressGamesTableViewCell")
                return cell
            }
            gamesCell.draw()
            return gamesCell
        }
        var index = indexPath.row
        if (!completedGameManager.inProgressGames.isEmpty) {
            index -= 1
        }
        
        let game = completedGameManager.myCompletedGames[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let gameCell = cell as? CompletedGameTableViewCell else {
            NSLog("cell was not type: CompletedGameTableViewCell")
            return cell
        }
        gameCell.draw(game: game)
        return gameCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from completed games view")
            return
        }
        switch segue.identifier! {
        case "inProgress": ()
        case "details":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                NSLog("completed games: tableView.indexPathForSelectedRow was nil")
                return
            }
            let controller = segue.destination as! CompletedGameViewController
            
            var index = indexPath.row
            if (!completedGameManager.inProgressGames.isEmpty) {
                index -= 1
            }
            
            controller.game = completedGameManager.myCompletedGames[index]
        default:
            NSLog("completed games controller: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    private func loadUserData() {
        if (!userManager.currentUserFetched()) {
            userManager.fetchCurrentUser { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alert(error)
                        return
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension CompletedViewController: GameWatcher {
    func gamesUpdated() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}
