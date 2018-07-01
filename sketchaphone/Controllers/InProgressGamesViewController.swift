import UIKit

class InProgressGamesViewController: LoadingViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGamesLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        completedGameManager.add(watcher: self)
        startLoading()
        completedGameManager.refetchInProgressIfOld({err in
            DispatchQueue.main.async {
                self.stopLoading()
                if let err = err {
                    self.alert(err)
                    return
                }
                self.updateUI()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completedGameManager.remove(watcher: self)
    }
    
    private func updateUI() {
        tableView.reloadData()
        noGamesLabel.isHidden = !completedGameManager.inProgressGames.isEmpty
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedGameManager.inProgressGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = completedGameManager.inProgressGames[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let gameCell = cell as? InProgressTableViewCell else {
            NSLog("cell was not type: InProgressTableViewCell")
            return cell
        }
        gameCell.draw(game: game)
        return gameCell
    }
}


extension InProgressGamesViewController: GameWatcher {
    func gamesUpdated() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}
