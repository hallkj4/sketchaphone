import StoreKit

protocol InAppPurchaseDelegate: AnyObject {
    func inAppPurchaseDelegate()
    func inAppPurchaseDelegate(error: String)
}

class InAppPurchaseBase: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var delegates = [InAppPurchaseDelegate]()
    var products: [SKProduct]?
    
    init(productIds: Set<String>) {
        super.init()
        
        let productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
        SKPaymentQueue.default().add(self)
    }
    
    func add(delegate: InAppPurchaseDelegate) {
        delegates.append(delegate)
    }
    
    func remove(delegate: InAppPurchaseDelegate) {
        if let index = delegates.index(where: {$0 === delegate}) {
            delegates.remove(at: index)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        NSLog("InAppPurchase loading failed, Error: \(error.localizedDescription)")
    }
    
    func getProduct(productId: String) -> SKProduct? {
        return products?.first(where: {product in
            product.productIdentifier == productId
        })
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased, .restored:
                handleSuccessful(transaction: transaction)
            case .failed, .deferred, .purchasing: ()
            }
        }
    }
    
    private func handleSuccessful(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: purchaseKey(transaction.payment.productIdentifier))
        SKPaymentQueue.default().finishTransaction(transaction)
        for delegate in delegates {
            delegate.inAppPurchaseDelegate()
        }
    }
    
    private func error(_ error: String) {
        for delegate in delegates {
            delegate.inAppPurchaseDelegate(error: error)
        }
    }
    
    func purchase(productId: String) {
        guard let product = getProduct(productId: productId) else {
            error("Could not load in-app purchases, please verify you have a working internet connection.")
            return
        }
        if (!SKPaymentQueue.canMakePayments()) {
            error("This users is not allowed to make purchases.")
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func hasPurchased(productId: String) -> Bool {
        return UserDefaults.standard.bool(forKey: purchaseKey(productId))
    }
    
    private func purchaseKey(_ productId: String) -> String {
        return "purchased-\(productId)"
    }
}
