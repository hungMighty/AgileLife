import UIKit
import StoreKit

class InAppPurchaseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var products: [SKProduct] = []
    fileprivate let refreshControl = UIRefreshControl()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "PSM Exam Store"
        let restoreButton = UIBarButtonItem(
            title: "Restore", style: .plain, target: self,
            action: #selector(InAppPurchaseVC.restoreTapped(_:))
        )
        navigationItem.rightBarButtonItem = restoreButton
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(InAppPurchaseVC.handlePurchaseNotification(_:)),
            name: .IAPHelperPurchaseNotification, object: nil
        )
        
        // TableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(
            self, action: #selector(InAppPurchaseVC.reloadProductsList), for: .valueChanged
        )
        
        reloadProductsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc fileprivate func reloadProductsList() {
        products = []
        tableView.reloadData()
        if refreshControl.isRefreshing == false {
            refreshControl.beginRefreshing()
        }
        
        IAPHelper.shared.requestProducts{ [weak self] success, products in
            guard let self = self, let products = products else { return }
            if success {
                self.products = products
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.tableView.contentOffset = CGPoint.zero
        }
    }
    
    @objc fileprivate func restoreTapped(_ sender: AnyObject) {
        IAPHelper.shared.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let notiObj = notification.object as? [String: Any],
            let productID = notiObj[IAPHelper.purchaseNotiProductIDKey] as? String,
            let index = products.index(where: { $0.productIdentifier == productID }) else { return }
        
        if let errorStr = notiObj[IAPHelper.purchaseNotiErrorKey] as? String, errorStr.isEmpty == false {
            let alert = UIAlertController(title: "Error!", message: errorStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if QuestionTemplate.isComboProduct(id: productID) {
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}

// MARK: - UITableViewDataSource

extension InAppPurchaseVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < products.count else {
            return UITableView.automaticDimension
        }
        let product = products[indexPath.row]
        let productID = product.productIdentifier
        if QuestionTemplate.isComboProduct(id: productID) &&
            IAPHelper.shared.isProductPurchased(productID) {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PurchaseCell.className(), for: indexPath) as! PurchaseCell
        
        let product = products[indexPath.row]
        let productID = product.productIdentifier
        
        cell.contentView.isHidden = false
        if QuestionTemplate.isComboProduct(id: productID) &&
            IAPHelper.shared.isProductPurchased(productID) {
            cell.contentView.isHidden = true
        } else {
            cell.product = product
            cell.buyButtonHandler = { [unowned self] product in
                guard IAPHelper.shared.isProductPurchased(product.productIdentifier),
                    let vc = UIStoryboard.viewController(
                        fromIdentifier: QuizzViewController.className()) as? QuizzViewController else {
                            IAPHelper.shared.buyProduct(product)
                            return
                }
                
                let questionTemplate = QuestionTemplate(rawValue: product.productIdentifier) ?? .easy
                vc.hidesBottomBarWhenPushed = true
                vc.questionTemplate = questionTemplate
                
                if let dict = UserDefaults.standard.value(forKey: questionTemplate.rawValue)
                    as? [String: Any],
                    let lastQuestionIndex = dict[quizzLastQuestionIndexKey] as? Int,
                    let score = dict[quizzLastScoreKey] as? Int {
                    
                    let alert = UIAlertController(
                        title: "Howdy!", message: "Do you want to continue where you left?", preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned self] (action) in
                        vc.curQuestionIndex = lastQuestionIndex
                        vc.score = score
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    alert.addAction(UIAlertAction(title: "No", style: .default) { [unowned self] (action) in
                        UserDefaults.standard.set(nil, forKey: questionTemplate.rawValue)
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension InAppPurchaseVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
