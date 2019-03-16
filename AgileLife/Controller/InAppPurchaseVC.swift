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
        
        PremiumProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.tableView.contentOffset = CGPoint.zero
        }
    }
    
    @objc fileprivate func restoreTapped(_ sender: AnyObject) {
        PremiumProducts.store.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let notiObj = notification.object as? [String: Any],
            let productID = notiObj[IAPHelper.purchaseNotiProductIDKey] as? String,
            let index = products.index(where: { $0.productIdentifier == productID }) else { return }
        
        if let errorStr = notiObj[IAPHelper.purchaseNotiErrorKey] as? String {
            let alert = UIAlertController(title: "Error!", message: errorStr, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

// MARK: - UITableViewDataSource

extension InAppPurchaseVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PurchaseCell.className(), for: indexPath) as! PurchaseCell
        
        let product = products[indexPath.row]
        cell.product = product
        cell.buyButtonHandler = { [unowned self] product in
            guard PremiumProducts.store.isProductPurchased(product.productIdentifier),
                let vc = UIStoryboard.viewController(
                    fromIdentifier: QuizzViewController.className()) as? QuizzViewController else {
                        PremiumProducts.store.buyProduct(product)
                        return
            }
            
            let template = QuestionTemplate(rawValue: product.productIdentifier) ?? .easy
            vc.hidesBottomBarWhenPushed = true
            vc.questionTemplate = template
            self.navigationController?.pushViewController(vc, animated: true)
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
