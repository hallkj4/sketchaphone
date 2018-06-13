import UIKit
class HomeViewController: LoadingViewController {
    @IBOutlet weak var pencil: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nav: UIStackView!
    
    @IBOutlet weak var newCompletedGamesBadgeLabel: UILabel!
    @IBOutlet weak var newCompletedGamesBadgeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completedGameManager.add(watcher: self)
        if (userManager.isSignedIn()) {
            completedGameManager.refetchCompleted()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateButtonsForSignIn()
    }
    
    func updateButtonsForSignIn() {
        if (userManager.isSignedIn()) {
            NSLog("signed in, showing home screen")
            self.startButton.isHidden = true
            self.pencil.isHidden = true
            self.nav.isHidden = false
            updateCompleteGamesBadge()
            return
        }
        NSLog("signed out, showing pencil and start button")
        self.startButton.isHidden = false
        self.pencil.isHidden = false
        self.nav.isHidden = true
        self.newCompletedGamesBadgeView.isHidden = true
    }
    
    private func updateCompleteGamesBadge() {
        self.newCompletedGamesBadgeView.isHidden = completedGameManager.myNewlyCompletedGames.isEmpty
        self.newCompletedGamesBadgeLabel.text = String(completedGameManager.myNewlyCompletedGames.count)
    }
    
    @IBAction func startButtonTouch() {
        userManager.promptSignIn()
    }
}

extension HomeViewController: GameWatcher {
    func gamesUpdated() {
        DispatchQueue.main.async {
            self.updateCompleteGamesBadge()
        }
    }
}
