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
        completedGameManager.refetchCompletedIfOld()
        updateUI()
        completedGameManager.add(watcher: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completedGameManager.remove(watcher: self)
    }
    
    private func updateUI() {
        tableView.reloadData()
        noGamesLabel.isHidden = completedGameManager.completedGameCount() > 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedGameManager.completedGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = completedGameManager.completedGameAt(indexPath.row)
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

extension CompletedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let game = completedGameManager.completedGameAt(indexPath.row)
        return game.turns.count >= gamesManager.numRounds
    }
}
