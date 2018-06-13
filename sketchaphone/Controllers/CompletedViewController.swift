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

