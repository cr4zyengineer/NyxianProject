//
//  UIThemedTableView.swift
//  Nyxian
//
//  Created by SeanIsTethered on 26.06.25.
//

import UIKit

class UIThemedTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_:)), name: Notification.Name("uiColorChangeNotif"), object: nil)
    }
    
    @objc func handleMyNotification(_ notification: Notification) {
        self.tableView.backgroundColor = currentTheme?.gutterBackgroundColor
        
        for cell in tableView.visibleCells {
            cell.backgroundColor = currentTheme?.backgroundColor
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class UIThemedTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_:)), name: Notification.Name("uiColorChangeNotif"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let savedIndex = UserDefaults.standard.integer(forKey: "SelectedTabIndex")
        if savedIndex < (viewControllers?.count ?? 0) {
            selectedIndex = savedIndex
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UserDefaults.standard.set(selectedIndex, forKey: "SelectedTabIndex")
    }
    
    @objc func handleMyNotification(_ notification: Notification) {
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        
        if let viewControllers = self.viewControllers {
            for case let nav as UINavigationController in viewControllers {
                nav.navigationBar.standardAppearance = currentNavigationBarAppearance
                nav.navigationBar.scrollEdgeAppearance = currentNavigationBarAppearance
                nav.navigationBar.scrollEdgeAppearance?.backgroundEffect = blurEffect
            }
        }
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = currentTheme?.gutterBackgroundColor
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance?.backgroundEffect = blurEffect
        }
    }
}
