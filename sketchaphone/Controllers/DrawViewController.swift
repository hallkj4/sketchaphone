import GoogleMobileAds
import UIKit
import Firebase

class DrawViewController: LoadingViewController, UIScrollViewDelegate, GADInterstitialDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var imageView: DrawableImageView!
    @IBOutlet weak var editBar: UIStackView!
    
    var interstitial: GADInterstitial!
    var completedGame: OpenGameDetailed?
    
    var colors: [UIColor]?
    let limitedColors: [UIColor] = [.black, .white]
    let fullColors : [UIColor] = [.black, .white, .red, .orange, .yellow, .green, .blue, .cyan]
    var colorButtons = [UIButton]()
    var adsToSkip = Int(LocalSQLiteManager.sharedInstance.getMisc(key: "adsToSkip") ?? "3") ?? 3

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        guard let game = gamesManager.currentGame else {
            alert("Error: currentGame was nil", handler: { _ in
                self.goHome()
            })
            return
        }
        let lastTurn = game.turns.last
        if (lastTurn == nil) {
            alert("Error: lastTurn was nil", handler: { _ in
                self.goHome()
            })
            return
        }
        if (lastTurn!.phrase == nil) {
            alert("Error: lastTurn did not have a phrase", handler: { _ in
                self.goHome()
            })
            return
        }
        gamesManager.renewLockDelegate = self
        phraseLabel.text = "Draw this: \(lastTurn!.phrase!)"
        
        setUpColors()
        createAndLoadInterstitial()
        imageView.reset()
    }
    
    func createAndLoadInterstitial() {
        if (inAppPurchaseModel.hasPurchasedNoAds() || self.adsToSkip > 0) {
            return
        }
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6287206061979264/9009711661")
        //NOTE: code for testing: ca-app-pub-3940256099942544/4411468910
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        doDone()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first!
    }
    
    @objc func colorTouch(sender: UIButton) {
        imageView.color = sender.backgroundColor!
        for colorButton in colorButtons {
            if (colorButton == sender) {
                colorButton.setTitle("\u{2713}", for: .normal)
            }
            else {
                colorButton.setTitle(" ", for: .normal)
            }
        }
    }
    
    @IBAction func undoTouch(_ sender: UIButton) {
        imageView.undo()
    }
    
    @IBAction func clearClick(_ sender: UIButton) {
        imageView.clear()
    }
    
    @IBAction func submitTouch(_ sender: UIBarButtonItem) {
        confirm("Are you ready to submit your drawing?", confirmedHandler: {
            if (networkOffline()) {
                self.alert("No network connection.")
                return
            }
            self.startLoading()
            gamesManager.draw(image: self.imageView.image!, callback: {(error, completedGame) in
                DispatchQueue.main.async {
                    self.stopLoading()
                    self.completedGame = completedGame
                    if let error = error {
                        self.alert("drawing could not be saved: \(error)")
                        return
                    }
                    if (inAppPurchaseModel.hasPurchasedNoAds()) {
                        self.doDone()
                        return
                    }
                    if (self.adsToSkip > 0) {
                        self.adsToSkip -= 1
                        LocalSQLiteManager.sharedInstance.putMisc(key: "adsToSkip", value: String(self.adsToSkip))
                        self.doDone()
                        return
                    }
                    if (self.interstitial.isReady) {
                        self.interstitial.present(fromRootViewController: self)
                        return
                    }
                    
                    NSLog("Ad wasn't ready")
                    self.doDone()
                }
            })
        })
    }
    
    private func doDone() {Analytics.logEvent(AnalyticsEventViewItem, parameters: [AnalyticsParameterItemName: "drew"])
        guard let game = completedGame?.fragments.gameDetailed else {
            goHome()
            return
        }
        if (game.turns.count < gamesManager.numRounds) {
            goHome()
            return
        }
        
        navigateTo(completedGame: game)
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        confirm("Are you sure you want to cancel?", confirmedHandler: {
            gamesManager.release()
            self.goHome()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == nil) {
            NSLog("nil segue from draw View")
            return
        }
        switch segue.identifier! {
        case "flag":
            let controller = segue.destination as! FlagViewController
            controller.game = gamesManager.currentGame?.fragments.gameDetailed
        default:
            NSLog("draw View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
    
    private func setUpColors() {
        let correctColors = inAppPurchaseModel.hasPurchasedColors() ? fullColors : limitedColors
        
        if (colors != nil && colors! == correctColors) {
            return
        }
        colors = correctColors
        while let button = colorButtons.popLast() {
            button.removeFromSuperview()
        }
        
        for color in colors! {
            let button = UIButton()
            button.backgroundColor = color
            button.setTitleColor(color.shifted(), for: .normal)
            button.borderColor = .black
            button.borderWidth = 1.0
            if (imageView.color == color) {
                button.setTitle("\u{2713}", for: .normal)
            }
            else {
                button.setTitle(" ", for: .normal)
            }
            button.addTarget(self, action: #selector(colorTouch(sender:)), for: .touchUpInside)
            colorButtons.append(button)
            editBar.insertArrangedSubview(button, at: 0)
        }
    }
}

extension DrawViewController: RenewLockDelegate {
    func renewLockError(_ error: String) {
        DispatchQueue.main.async {
            self.alert(error)
        }
    }
}
