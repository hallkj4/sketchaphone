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
        
        NSLog("fetching products")
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
        NSLog("Got products: \(products?.count ?? 0)")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        NSLog("InAppPurchase loading failed, Error: \(error.localizedDescription)")
    }
    
    func getProduct(productId: String) -> SKProduct? {
        return products?.first(where: {product in
            product.productIdentifier == productId
        })
    }
    
    func getPrice(productId: String) -> String? {
        guard let product = getProduct(productId: productId) else {
            return nil
        }
        return "\(product.priceLocale.currencySymbol ?? product.priceLocale.currencyCode ?? "$")\(product.price)"
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        NSLog("paymentQueue updatedTransactions: \(transactions.count) - \(transactions.first!.transactionState.rawValue)")
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased, .restored:
                handleSuccessful(transaction: transaction)
            case .failed:
                cleanup(transaction: transaction)
            case .deferred, .purchasing: ()
            }
        }
    }
    
    private func handleSuccessful(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: purchaseKey(transaction.payment.productIdentifier))
        for delegate in delegates {
            delegate.inAppPurchaseDelegate()
        }
        cleanup(transaction: transaction)
    }
    
    private func handleUnsuccessful(transaction: SKPaymentTransaction) {
        guard let transactionError = transaction.error as NSError? else {
            error("Payment failed, unknown reason: transaction.error could not be cast as an NSError")
            cleanup(transaction: transaction)
            return
        }
            
        if (transactionError.code == SKError.paymentCancelled.rawValue) {
            cleanup(transaction: transaction)
            return
        }
        
        error("Purchase failed: \(transactionError.localizedDescription)")
        cleanup(transaction: transaction)
    }
    
    private func cleanup(transaction: SKPaymentTransaction) {
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
    
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func purchaseKey(_ productId: String) -> String {
        return "purchased-\(productId)"
    }
}
