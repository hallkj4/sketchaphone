import UIKit

class TurnSavedViewController: LoadingViewController {
    
    var completion: (() -> Void)?
    
    @IBAction func okTouch() {
        dismiss(animated: true)
        completion?()
    }
    
    
    @IBAction func dontShowTouch() {
        LocalSQLiteManager.sharedInstance.putMisc(key: "dontShowTurnSaved", value: "true")
        dismiss(animated: true)
        completion?()
    }
}
