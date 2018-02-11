import StoreKit

var inAppPurchaseModel = InAppPurchaseModel()
class InAppPurchaseModel {
    
    private let noAdsIdentifier = "noads1"
    private let colorsIdentifier = "colors1"
    private let allIdentifier = "colorsAndNoAds1"
    
    private let inAppPurchaseBase: InAppPurchaseBase
    
    init() {
        let productIds: Set = [noAdsIdentifier, colorsIdentifier, allIdentifier]
        inAppPurchaseBase = InAppPurchaseBase(productIds: productIds)
    }
    
    func ready() {
        
    }
    
    func add(delegate: InAppPurchaseDelegate) {
        inAppPurchaseBase.add(delegate: delegate)
    }
    
    func remove(delegate: InAppPurchaseDelegate) {
        inAppPurchaseBase.remove(delegate: delegate)
    }
    
    func noAdsPrice() -> String? {
        return inAppPurchaseBase.getPrice(productId: noAdsIdentifier)
    }
    
    func colorsPrice() -> String? {
        return inAppPurchaseBase.getPrice(productId: colorsIdentifier)
    }
    
    func allPrice() -> String? {
        return inAppPurchaseBase.getPrice(productId: allIdentifier)
    }
    
    func purchaseNoAds() {
        inAppPurchaseBase.purchase(productId: noAdsIdentifier)
    }
    
    func purchaseColors() {
        inAppPurchaseBase.purchase(productId: colorsIdentifier)
    }
    
    func purchaseAll() {
        inAppPurchaseBase.purchase(productId: allIdentifier)
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
        inAppPurchaseBase.restorePurchases()
    }
}
