import UIKit

class CantViewInProgressViewController: LoadingViewController {
    
    @IBAction func okTouch() {
        dismiss(animated: true)
    }
}
