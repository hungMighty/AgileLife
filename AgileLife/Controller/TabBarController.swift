//
//  TabBarVC.swift
//  VietnamWorks
//
//  Created by Ahri on 12/19/18.
//  Copyright © 2018 Vietnamworks. All rights reserved.
//

import UIKit


enum TabIndex: Int, CaseIterable {
    case home = 0, purchase
}

class TabBarController: UITabBarController {
    
    var homeVC: HomeViewController!
    var purchaseVC: InAppPurchaseVC!
    
    // MARK: View lifecycles
    
    deinit {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        initVCs()
        customTabBarUI()
        customTabBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Config UI
    
    fileprivate func initVCs() {
        var navCons = [UINavigationController]()
        
        for tabType in TabIndex.allCases {
            switch tabType {
            case .home:
                if let homeNav = UIStoryboard.viewController(fromIdentifier: "HomeNavController")
                    as? UINavigationController {
                    
                    self.homeVC = (homeNav.viewControllers.first as! HomeViewController)
                    navCons.append(homeNav)
                }
            case .purchase:
                if let purchaseNav = UIStoryboard.viewController(fromIdentifier: "InAppPurchaseNavController")
                    as? UINavigationController {

                    self.purchaseVC = (purchaseNav.viewControllers.first as! InAppPurchaseVC)
                    navCons.append(purchaseNav)
                }
            }
        }
        
        self.viewControllers = navCons
    }
    
    fileprivate func customTabBarUI() {
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.blue
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font : UIFont(name: "Verdana", size: 10)!], for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected
        )
    }
    
    fileprivate func customTabBarItems() {
        let homeTabItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tabIcon_free")?
                .withRenderingMode(.alwaysOriginal) ?? UIImage(),
            tag: TabIndex.home.rawValue
        )
        homeTabItem.selectedImage = UIImage(named: "tabIcon_free_selected")?
            .withRenderingMode(.alwaysOriginal)
        homeTabItem.title = "Free"
        self.homeVC.tabBarItem = homeTabItem
        
        let myJobsTabItem = UITabBarItem(
            title: "Advanced",
            image: UIImage(named: "tabIcon_shopCart")?
                .withRenderingMode(.alwaysOriginal) ?? UIImage(),
            tag: TabIndex.purchase.rawValue
        )
        myJobsTabItem.selectedImage = UIImage(named: "tabIcon_shopCart_selected")?
            .withRenderingMode(.alwaysOriginal)
        self.purchaseVC.tabBarItem = myJobsTabItem
    }
    
}

// MARK: - UITabBarControllerDelegate
    
extension TabBarController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabIndex = tabBar.items?.firstIndex(of: item),
            let _ = TabIndex(rawValue: tabIndex) {
        }
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
    
}

