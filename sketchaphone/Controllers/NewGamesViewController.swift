import UIKit

class NewGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GameWatcher {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO pull to refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesManager.add(watcher: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (userManager.currentUser == nil) {
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "newUser", sender: nil)
            })
        }
    }
    
    func gamesUpdated() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesManager.newGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let game = gamesManager.newGames[indexPath.row]
        cell.textLabel!.text = "Game created by \(game.creator.name)"
        cell.detailTextLabel!.text = "Turns taken: \(game.turns.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = gamesManager.newGames[indexPath.row]
        gamesManager.lock(game: game)
        
        //TODO - callback
        //TODO loading animation
        //TODO verify turn count
        if (game.turns.count % 2 == 1) {
            performSegue(withIdentifier: "draw", sender: nil)
            return
        }
        performSegue(withIdentifier: "guess", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from my new games view")
            return
        }
        switch segue.identifier! {
        case "newUser": ()
        case "newGame": ()
            //TODO - check on account limits - you can only create X games
        case "draw":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                NSLog("new games: tableView.indexPathForSelectedRow was nil")
                return
            }
            let controller = segue.destination as! DrawViewController
            controller.game = gamesManager.newGames[indexPath.row]
        case "guess":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                NSLog("new games: tableView.indexPathForSelectedRow was nil")
                return
            }
            let controller = segue.destination as! GuessViewController
            controller.game = gamesManager.newGames[indexPath.row]
        default:
            NSLog("new games controller: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    
    @IBAction func unwindSegue(segue:UIStoryboardSegue) {
        
    }
}

