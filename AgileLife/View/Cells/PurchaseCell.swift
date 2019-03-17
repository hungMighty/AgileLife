import UIKit
import StoreKit

class PurchaseCell: UITableViewCell {
    
    @IBOutlet weak var discountIcon: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var discountLb: InsetsLb!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var purchaseBtn: UIButton!
    
    // Constraints
    @IBOutlet weak var discountIconWidth: NSLayoutConstraint!
    @IBOutlet weak var discountIconTrailingSpace: NSLayoutConstraint!
    
    fileprivate var indicator: UIActivityIndicatorView?
    
    enum PurchaseBtnState {
        case showPrice, beginTest
        
        var theme: UIColor {
            switch self {
            case .showPrice:
                return UIColor(red: 72, green: 138, blue: 247)
            case .beginTest:
                return .red
            }
        }
        
        var title: String {
            switch self {
            case .showPrice:
                return ""
            case .beginTest:
                return "Begin"
            }
        }
    }
    
    fileprivate static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            let storeProductTitle = product.localizedTitle
            let storeProductDescription = product.localizedDescription
            var productTitleTxt = storeProductTitle
            var productDiscountTxt = ""
            if let range = storeProductTitle.lowercased().range(of: "save") {
                let lowerBound = range.lowerBound
                productTitleTxt = String(storeProductTitle[..<lowerBound])
                productDiscountTxt = String(storeProductTitle[lowerBound..<storeProductTitle.endIndex])
            }
            var numOfQuestionsTxt = ""
            if let range = storeProductDescription.lowercased().range(of: "question") {
                let num = storeProductDescription[storeProductDescription.startIndex..<range.lowerBound]
                numOfQuestionsTxt = String("\(num)questions!"
                )
            }
            
            discountIcon.image = nil
            discountIconWidth.constant = 0
            discountIconTrailingSpace.constant = 0
            titleLb.text = productTitleTxt
            discountLb.isHidden = true
            descriptionLb.text = numOfQuestionsTxt
            indicator?.removeFromSuperview()
            indicator = nil
            
            if IAPHelper.shared.isProductPurchased(product.productIdentifier) {
                setupPurchaseBtn(state: .beginTest)
                
            } else if IAPHelper.canMakePayments() {
                PurchaseCell.priceFormatter.locale = product.priceLocale
                setupPurchaseBtn(
                    state: .showPrice, price: PurchaseCell.priceFormatter.string(from: product.price)
                )
                discountLb.text = productDiscountTxt
                if productDiscountTxt.isEmpty {
                    discountLb.isHidden = true
                } else {
                    discountIconWidth.constant = 26
                    discountIconTrailingSpace.constant = 6
                    discountIcon.image = UIImage(named: "icon_discount")
                    discountLb.isHidden = false
                    descriptionLb.text = ""
                }
                
            } else {
                titleLb.text = "Not available"
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        discountIcon.image = nil
        titleLb.text = nil
        discountLb.isHidden = true
        discountLb.text = nil
        descriptionLb.text = nil
        purchaseBtn.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let discountLbLayer = discountLb.layer
        discountLbLayer.masksToBounds = true
        discountLbLayer.cornerRadius = 8
        
        discountLb.textColor = .white
        discountLb.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
    }
    
    fileprivate func setupPurchaseBtn(state: PurchaseBtnState, price: String? = nil) {
        purchaseBtn.isHidden = false
        
        let purchaseBtnLayer = purchaseBtn.layer
        purchaseBtnLayer.masksToBounds = true
        purchaseBtnLayer.cornerRadius = 6
        purchaseBtnLayer.borderWidth = 1.5
        
        let color = state.theme
        purchaseBtnLayer.borderColor = color.cgColor
        purchaseBtn.setTitleColor(color, for: .normal)
        
        if let price = price {
            purchaseBtn.setTitle(price, for: .normal)
        } else {
            purchaseBtn.setTitle(state.title, for: .normal)
        }
    }
    
    fileprivate func newLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        indicator.style = .gray
        indicator.startAnimating()
        
        return indicator
    }
    
    @IBAction func priceBtnTap(_ sender: Any) {
        if IAPHelper.shared.isProductPurchased(product!.productIdentifier) == false {
            purchaseBtn.isHidden = true
            let indicator = newLoadingIndicator()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(indicator)
            NSLayoutConstraint(
                item: indicator, attribute: .centerY, relatedBy: .equal,
                toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(
                item: indicator, attribute: .trailing, relatedBy: .equal,
                toItem: self, attribute: .trailing, multiplier: 1.0, constant: -30).isActive = true
            self.indicator = indicator
        }
        
        buyButtonHandler?(product!)
    }
    
}
