import GoogleMobileAds
import UIKit

class DrawViewController: LoadingViewController, UIScrollViewDelegate, GADInterstitialDelegate {
    var game: OpenGameDetailed?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var imageView: DrawableImageView!
    @IBOutlet weak var editBar: UIStackView!
    
    var interstitial: GADInterstitial!
    
    var colors: [UIColor]?
    let limitedColors: [UIColor] = [.black, .white]
    let fullColors : [UIColor] = [.black, .white, .red, .orange, .yellow, .green, .blue, .cyan]
    var colorButtons = [UIButton]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (game == nil) {
            return
        }
        let lastTurn = game!.turns.last
        if (lastTurn == nil) {
            alert("Error: lastTurn was nil", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        if (lastTurn!.phrase == nil) {
            alert("Error: lastTurn did not have a phrase", handler: { _ in
                self.dismiss(animated: false)
            })
            return
        }
        phraseLabel.text = "Draw this: \(lastTurn!.phrase!)"
        
        setUpColors()
        createAndLoadInterstitial()
        imageView.reset()
    }
    
    func createAndLoadInterstitial() {
        if (inAppPurchaseModel.hasPurchasedNoAds()) {
            return
        }
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        //TODO - use this for prod ca-app-pub-6287206061979264/9009711661
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        dismiss(animated: true)
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        dismiss(animated: true)
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
        confirm("Are you ready to submit your drawing?", handler: {confirmed in
            if (confirmed) {
                self.startLoading()
                gamesManager.draw(game: self.game!, image: self.imageView.image!, callback: {(error, completed) in
                    self.stopLoading()
                    if let error = error {
                        self.alert("drawing could not be saved: \(error)")
                        return
                    }
                    self.game = nil
                    
                    if (inAppPurchaseModel.hasPurchasedNoAds()) {
                        self.dismiss(animated: true)
                        return
                    }
                    if (self.interstitial.isReady) {
                        self.interstitial.present(fromRootViewController: self)
                        return
                    }
                    
                    //TODO -check if the drawing is done...
                    
                    NSLog("Ad wasn't ready")
                    self.dismiss(animated: true)
                })
            }
        })
    }
    
    @IBAction func cancelTouch(_ sender: UIBarButtonItem) {
        confirm("Are you sure you want to cancel?", handler: {confirmed in
            if (confirmed) {
                gamesManager.release(game: self.game!)
                self.game = nil
                self.dismiss(animated: true)
            }
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
            controller.game = game?.fragments.gameDetailed
        default:
            NSLog("draw View: unhandled segue identifier: \(segue.identifier!)")
        }
    }
}
