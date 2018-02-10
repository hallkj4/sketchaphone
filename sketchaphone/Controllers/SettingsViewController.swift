import UIKit
import StoreKit

class SettingsViewController: LoadingViewController, UITextFieldDelegate, InAppPurchaseDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    
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
//        if (inAppPurchaseModel.) {
//
//        }
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
        userManager.set(name: nameField.text!)
        //TODO callback / loading screen
        return true
    }
    
    @IBAction func removeAdsTouch() {
        inAppPurchaseModel.purchaseNoAds()
    }
    
    @IBAction func addColorsTouch() {
        inAppPurchaseModel.purchaseColors()
    }
    
    @IBAction func purchaseAllTouch() {
        inAppPurchaseModel.purchaseAll()
    }
    @IBAction func restorePurchasesTouch() {
        //TODO LOck screen...
        inAppPurchaseModel.restorePurchases()
    }
    
    
    func inAppPurchaseDelegate() {
        DispatchQueue.main.async(execute: {
            self.updateViewForPurchases()
        })
    }
    
    func inAppPurchaseDelegate(error: String) {
        alert(error)
    }
    
}
