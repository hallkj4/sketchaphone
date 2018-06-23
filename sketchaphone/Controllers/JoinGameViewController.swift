import UIKit
import Firebase

class JoinGameViewController: LoadingViewController, JoinGameDelgate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if (networkOffline()) {
            alert("No network connection.", handler: { _ in
                self.goHome()
            })
            return
        }
        Analytics.logEvent("joiningGame", parameters: nil)
        
        gamesManager.joinGame(delegate: self)
    }
    
    
    func gameJoined() {
        guard let game = gamesManager.currentGame else {
            couldNotJoinGame(message: "currentGame was nil")
            return
        }
        DispatchQueue.main.async {
            if (game.turns.count % 2 == 1) {
                self.performSegue(withIdentifier: "draw", sender: nil)
                return
            }
            self.performSegue(withIdentifier: "guess", sender: nil)
        }
    }
    
    func couldNotJoinGame(message: String) {
        DispatchQueue.main.async {
            self.alert(message, handler: { _ in
                self.goHome()
            })
        }
    }
}

