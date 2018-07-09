import UIKit

class WelcomeViewController: LoadingViewController {
    
    var completion: (() -> Void)?
    
    @IBAction func okTouch() {
        dismiss(animated: true)
        completion?()
    }
}
