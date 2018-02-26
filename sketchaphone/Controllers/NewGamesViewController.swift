import UIKit

class NewGamesViewController: LoadingViewController, UITableViewDataSource, UITableViewDelegate, GameWatcher {
    
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
        return gamesManager.openGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let game = gamesManager.openGames[indexPath.row]
        cell.textLabel!.text = "Turns taken: \(game.turns.count)"
        cell.detailTextLabel!.text = "TODO"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = gamesManager.openGames[indexPath.row]
        startLoading()
        gamesManager.lock(game: game, callback: {(game, error) in
            self.stopLoading()
            if let error = error {
                self.alert("could not lock game: \(error.localizedDescription)")
                return
            }
            
            guard let game = game else {
                self.alert("no game was passed, but no error either!")
                return
            }
            
            if (game.turns.count % 2 == 1) {
                self.performSegue(withIdentifier: "draw", sender: nil)
                return
            }
            self.performSegue(withIdentifier: "guess", sender: nil)
        })
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
            controller.game = gamesManager.openGames[indexPath.row]
        case "guess":
            guard let indexPath = tableView.indexPathForSelectedRow else {
                NSLog("new games: tableView.indexPathForSelectedRow was nil")
                return
            }
            let controller = segue.destination as! GuessViewController
            controller.game = gamesManager.openGames[indexPath.row]
        default:
            NSLog("new games controller: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    
    @IBAction func unwindSegue(segue:UIStoryboardSegue) {
        
    }
}

