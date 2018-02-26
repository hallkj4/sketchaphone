import UIKit

class CompletedViewController: UIViewController, UITableViewDataSource, GameWatcher {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesManager.add(watcher: self)
    }
    
    func gamesUpdated() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesManager.completedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = gamesManager.completedGames[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var firstTurn = game.turns.first
        cell.textLabel!.text = "Game created by \(firstTurn?.user.name ?? "unknown")"
        cell.detailTextLabel!.text = "Starting phrase: \(firstTurn?.phrase ?? "unknown")"
        
        return cell
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
            controller.game = gamesManager.completedGames[indexPath.row]
        default:
            NSLog("completed games controller: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    
}

