import StoreKit

let inAppPurchaseModel = InAppPurchaseModel()

class InAppPurchaseModel {
    
    let noAdsIdentifier = "noads1"
    let colorsIdentifier = "colors1"
    let allIdentifier = "colorsAndNoAds1"
    
    let inAppPurchaseBase: InAppPurchaseBase
    
    init() {
        let productIds: Set = [noAdsIdentifier, colorsIdentifier, allIdentifier]
        inAppPurchaseBase = InAppPurchaseBase(productIds: productIds)
    }
    
    func add(delegate: InAppPurchaseDelegate) {
        inAppPurchaseBase.add(delegate: delegate)
    }
    
    func remove(delegate: InAppPurchaseDelegate) {
        inAppPurchaseBase.remove(delegate: delegate)
    }
    
    func purchaseNoAds() {
        inAppPurchaseBase.purchase(productId: noAdsIdentifier)
    }
    
    func purchaseColors() {
        inAppPurchaseBase.purchase(productId: colorsIdentifier)
    }
    
    func purchaseAll() {
        inAppPurchaseBase.purchase(productId: colorsIdentifier)
    }
    
    func hasPurchasedAll() -> Bool {
        return inAppPurchaseBase.hasPurchased(productId: allIdentifier)
    }
    
    func hasPurchasedNoAds() -> Bool {
        if (hasPurchasedAll()) {
            return true
        }
        return inAppPurchaseBase.hasPurchased(productId: noAdsIdentifier)
    }
    
    func hasPurchasedColors() -> Bool {
        if (hasPurchasedAll()) {
            return true
        }
        return inAppPurchaseBase.hasPurchased(productId: colorsIdentifier)
    }
    
    func restorePurchases() {
        //TODO
    }
}
