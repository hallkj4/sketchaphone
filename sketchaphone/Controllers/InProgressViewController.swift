import UIKit

class InProgressViewController: UIViewController, UITableViewDataSource, GameWatcher {
    
    //TODO - invite links
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesManager.add(watcher: self)
    }
    
    func gamesUpdated() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesManager.inProgressGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = gamesManager.inProgressGames[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel!.text = "Game created by \(game.creator.name)"
        cell.detailTextLabel!.text = "Turns taken: \(game.turns.count)"
        
        return cell
    }
    
    
}
