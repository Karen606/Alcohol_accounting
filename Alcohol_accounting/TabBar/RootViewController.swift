//
//  RootViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 14.05.25.
//


import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
            self.navigationController?.viewControllers = [tabBarVC]
        }
    }
}
