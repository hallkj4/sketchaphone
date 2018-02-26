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
        guard let turnByYouIndex = game.turns.index(where: {$0.user.id == userManager.currentUser?.id}) else {
            cell.textLabel!.text = "error: turn by you could not be found"
            return cell
        }
        
        let turnByYou = game.turns[turnByYouIndex]
        guard let phrase = turnByYou.phrase ?? game.turns[turnByYouIndex - 1].phrase else {
            cell.textLabel!.text = "no phrases found!"
            return cell
        }

        cell.textLabel!.text = phrase
        cell.detailTextLabel!.text = "Turns: \(game.turns.count)"
        //TODO show some timestamps maybe
        
        return cell
    }
    
    
}
