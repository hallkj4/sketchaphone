import UIKit
import StoreKit

class SettingsViewController: LoadingViewController, UITextFieldDelegate, InAppPurchaseDelegate {
    
    
    @IBOutlet weak var purchaseNoAdsButton: UIButton!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var purchaseColorsButton: UIButton!
    @IBOutlet weak var colorsLabel: UILabel!
    @IBOutlet weak var purchaseAllButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
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
        
        nameField.text = userManager.currentUser?.name
        updateViewForPurchases()
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameField) {
            return nameEditingDone()
        }
        return true
    }
    
    func nameEditingDone() -> Bool {
        if (nameField.text == nil || nameField.text == "") {
            alert("Name cannot be blank")
            return false
        }
        self.view.endEditing(true)
        startLoading()
        userManager.set(name: nameField.text!, callback: {(error) in
            self.stopLoading()
            if let error = error {
                self.alert("error setting name, please edit to try again: \(error.localizedDescription)")
            }
        })
        return true
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
