import UIKit
import Firebase

class JoinGameViewController: LoadingViewController {
    
    let tips = ["When drawing can pinch with two fingers to zoom in, and scroll with two fingers.",
                "Additional colors are availible in the store - click on the shopping cart to see what is availible.",
                "Doodle Game is fun to play with your friends in the same room, or with people over the internet!",
                "Drawings should not contain letters or numbers. That defeats the point of the game.",
                "Don't like ads?  You can disable them in the store.",
                "Share Doodle Game with your friends!",
                "Turn on push notifications so you can see when your games are complete.",
                "Doodle Game was created by Michael Economy",
                "Enjoy doodle game? Leave a review in the app store!",
                "If you cancel out of a game - the server will try and skip that game when you join the next one",
                "Life is the art of drawing without an eraser -John W. Gardner",
                "Drawing is the honesty of the art. There is no possibility of cheating. It is either good or bad. -Salvador Dali",
                "A drawing is simply a line going for a walk -Paul Klee",
                "I prefer drawing to talking. Drawing is faster, and leaves less room for lies. -Le Corbusier",
                "A drawing is always dragged down to the level of its caption. -James Thurber",
                "Discipline in art is a fundamental struggle to understand oneself, as much as to understand what one is drawing. -Henry Moore",
                "The first writing of the human being was drawing, not writing -Marjane Satrapi",
                "Lose your inhibitions about drawing and just do it -Chris Riddell"]
    
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipLabel.text = tips[Int(arc4random_uniform(UInt32(tips.count)))]
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if (networkOffline()) {
            alert("No network connection.", handler: { _ in
                self.goHome()
            })
            return
        }
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [AnalyticsParameterItemName: "joiningGame"])
        
        gamesManager.joinGame(delegate: self)
    }
}

extension JoinGameViewController: JoinGameDelgate {
    
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

