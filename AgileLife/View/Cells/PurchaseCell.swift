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
        case showPrice, begin
        
        var color: UIColor {
            switch self {
            case .showPrice:
                return UIColor(red: 72, green: 138, blue: 247)
            case .begin:
                return .red
            }
        }
        
        var title: String {
            switch self {
            case .showPrice:
                return ""
            case .begin:
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
            
            selectionStyle = .none
            let fullTitle = product.localizedTitle
            var title = fullTitle
            var discountTxt = ""
            
            if let range = fullTitle.lowercased().range(of: "save") {
                let lowerBound = range.lowerBound
                title = String(fullTitle[..<lowerBound])
                discountTxt = String(fullTitle[lowerBound..<fullTitle.endIndex])
            }
            
            discountIconWidth.constant = 0
            discountIconTrailingSpace.constant = 0
            discountIcon.image = nil
            titleLb.text = title
            discountLb.isHidden = true
            descriptionLb.text = "20 questions!"
            indicator?.removeFromSuperview()
            indicator = nil
            
            if PremiumProducts.store.isProductPurchased(product.productIdentifier) {
                setupPurchaseBtn(state: .begin)
                
            } else if IAPHelper.canMakePayments() {
                PurchaseCell.priceFormatter.locale = product.priceLocale
                setupPurchaseBtn(
                    state: .showPrice, price: PurchaseCell.priceFormatter.string(from: product.price)
                )
                discountLb.text = discountTxt
                if discountTxt.isEmpty {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        discountIcon.image = nil
        discountLb.isHidden = true
        discountLb.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let discountLbLayer = discountLb.layer
        discountLbLayer.masksToBounds = true
        discountLbLayer.cornerRadius = 8
        
        discountLb.textColor = .white
        discountLb.backgroundColor = UIColor(red: 220, green: 20, blue: 60)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLb.text = ""
        discountLb.text = ""
        discountLb.isHidden = true
        descriptionLb.text = ""
        purchaseBtn.setTitle("", for: .normal)
    }
    
    fileprivate func setupPurchaseBtn(state: PurchaseBtnState, price: String? = nil) {
        purchaseBtn.isHidden = false
        
        let purchaseBtnLayer = purchaseBtn.layer
        purchaseBtnLayer.masksToBounds = true
        purchaseBtnLayer.cornerRadius = 6
        purchaseBtnLayer.borderWidth = 1.5
        
        let color = state.color
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
        
        buyButtonHandler?(product!)
    }
    
}
