import UIKit
class HomeViewController: LoadingViewController {
    @IBOutlet weak var pencil: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nav: UIStackView!
    
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
            return
        }
        NSLog("signed out, showing pencil and start button")
        self.startButton.isHidden = false
        self.pencil.isHidden = false
        self.nav.isHidden = true
    }
    
    @IBAction func startButtonTouch() {
        userManager.promptSignIn()
    }
}
