//
//  TabBarViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
        self.viewControllers = [UIStoryboard(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeViewController"), UIStoryboard(name: "AlcoholForm", bundle: .main).instantiateViewController(withIdentifier: "AlcoholFormViewController"), UIStoryboard(name: "Report", bundle: .main).instantiateViewController(withIdentifier: "ReportViewController"), UIStoryboard(name: "Settings", bundle: .main).instantiateViewController(withIdentifier: "SettingsViewController")]
        self.delegate = self
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is HomeViewController:
            self.setNavigationTitle(title: "")
        case is AlcoholFormViewController:
            self.setNavigationTitle(title: "Add alcohol")
        case is ReportViewController:
            self.setNavigationTitle(title: "Report")
        case is SettingsViewController:
            self.setNavigationTitle(title: "Setting")
        default:
            break
        }
    }
}
