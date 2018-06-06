import UIKit
import StoreKit

class StoreViewController: LoadingViewController, InAppPurchaseDelegate {
    
    
    @IBOutlet weak var purchaseNoAdsButton: UIButton!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var purchaseColorsButton: UIButton!
    @IBOutlet weak var colorsLabel: UILabel!
    @IBOutlet weak var purchaseAllButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        display(price: inAppPurchaseModel.noAdsPrice(), button: purchaseNoAdsButton)
        display(price: inAppPurchaseModel.colorsPrice(), button: purchaseColorsButton)
        display(price: inAppPurchaseModel.allPrice(), button: purchaseAllButton)
    }
    
    private func display(price: String?, button: UIButton) {
        if (price == nil) {
            return
        }
        let newTitle = "\(button.title(for: .normal)!) - \(price!)"
        button.setTitle(newTitle, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        inAppPurchaseModel.add(delegate: self)
        updateViewForPurchases()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inAppPurchaseModel.remove(delegate: self)
    }
    
    private func updateViewForPurchases() {
        if (inAppPurchaseModel.hasPurchasedColors()) {
            colorsLabel.isHidden = false
            purchaseColorsButton.isHidden = true
        }
        else {
            colorsLabel.isHidden = true
            purchaseColorsButton.isHidden = false
        }
        if (inAppPurchaseModel.hasPurchasedNoAds()) {
            noAdsLabel.isHidden = false
            purchaseNoAdsButton.isHidden = true
        }
        else {
            noAdsLabel.isHidden = true
            purchaseNoAdsButton.isHidden = false
        }
        
        if (inAppPurchaseModel.hasPurchasedNoAds() && inAppPurchaseModel.hasPurchasedColors()) {
            restorePurchasesButton.isHidden = true
            purchaseAllButton.isHidden = true
        }
        else if (inAppPurchaseModel.hasPurchasedNoAds() && inAppPurchaseModel.hasPurchasedColors()) {
            restorePurchasesButton.isHidden = false
            purchaseAllButton.isHidden = true
        }
        else {
            restorePurchasesButton.isHidden = false
            purchaseAllButton.isHidden = false
        }
    }
    
    @IBAction func removeAdsTouch() {
        startLoading()
        inAppPurchaseModel.purchaseNoAds()
    }
    
    @IBAction func addColorsTouch() {
        startLoading()
        inAppPurchaseModel.purchaseColors()
    }
    
    @IBAction func purchaseAllTouch() {
        startLoading()
        inAppPurchaseModel.purchaseAll()
    }
    
    @IBAction func restorePurchasesTouch() {
        startLoading()
        inAppPurchaseModel.restorePurchases()
    }
    
    func inAppPurchaseDelegate() {
        DispatchQueue.main.async(execute: {
            self.stopLoading()
            self.updateViewForPurchases()
        })
    }
    
    func inAppPurchaseDelegate(error: String) {
        alert(error)
    }
    
}
