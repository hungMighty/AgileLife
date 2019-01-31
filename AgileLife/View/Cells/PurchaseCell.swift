import UIKit
import StoreKit

class PurchaseCell: UITableViewCell {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            self.selectionStyle = .none
            textLabel?.text = product.localizedTitle
            
            if PremiumProducts.store.isProductPurchased(product.productIdentifier) {
                self.selectionStyle = .default
                accessoryType = .checkmark
                accessoryView = nil
                detailTextLabel?.text = ""
            } else if IAPHelper.canMakePayments() {
                PurchaseCell.priceFormatter.locale = product.priceLocale
                detailTextLabel?.text = PurchaseCell.priceFormatter.string(from: product.price)
                accessoryType = .none
                accessoryView = self.newBuyButton()
            } else {
                detailTextLabel?.text = "Not available"
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
    
    fileprivate func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(tintColor, for: .normal)
        button.setTitle("Buy", for: .normal)
        button.addTarget(self, action: #selector(PurchaseCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    @objc fileprivate func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
    
}
