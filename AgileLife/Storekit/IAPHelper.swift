import StoreKit
import KeychainSwift

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    private init(productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
        for id in productIds {
            let purchased = UserDefaults.standard.bool(forKey: id)
            if purchased {
                purchasedProductIdentifiers.insert(id)
                print("Previously purchased: \(id)")
            } else {
                print("Not purchased: \(id)")
            }
        }
        
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    static let shared = IAPHelper(productIds: QuestionTemplate.allStoreProductIDs)
    
}

// MARK: - Handle Transactions

extension IAPHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

// MARK: - SKProductsRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
}

// MARK: - SKPaymentTransactionObserver
extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue,
                             updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier, isSuccess: true)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier, isSuccess: true)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        var returnError = ""
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            
            returnError = "Transaction Error: \(localizedDescription)"
        }
        deliverPurchaseNotificationFor(
            identifier: transaction.payment.productIdentifier, isSuccess: false,
            transactionError: returnError
        )
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    static let purchaseNotiProductIDKey = "ProductID"
    static let purchaseNotiIsSuccessKey = "IsSuccess"
    static let purchaseNotiErrorKey = "PurchaseError"
    
    private func deliverPurchaseNotificationFor(
        identifier: String?, isSuccess: Bool, transactionError: String = "") {
        
        guard var identifier = identifier else { return }
        if isSuccess {
            if identifier == QuestionTemplate.COMBO1.rawValue {
                for id in QuestionTemplate.productIDsFor(combo: .COMBO1) {
                    purchasedProductIdentifiers.insert(id.rawValue)
                    UserDefaults.standard.set(true, forKey: id.rawValue)
                }
            } else {
                purchasedProductIdentifiers.insert(identifier)
                UserDefaults.standard.set(true, forKey: identifier)
                
                if var combo = QuestionTemplate.getComboIDStrings(fromProductID: identifier) {
                    let comboID = combo.removeFirst()
                    let comboSet: Set<ProductIdentifier> = Set(combo)
                    if comboSet.isSubset(of: purchasedProductIdentifiers) {
                        purchasedProductIdentifiers.insert(comboID)
                        UserDefaults.standard.set(true, forKey: comboID)
                        identifier = comboID
                    }
                }
            }
        }
        let postObj: [String: Any] = [
            IAPHelper.purchaseNotiProductIDKey: identifier,
            IAPHelper.purchaseNotiIsSuccessKey: isSuccess,
            IAPHelper.purchaseNotiErrorKey: transactionError
        ]
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: postObj)
    }
    
}
