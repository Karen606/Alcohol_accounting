//
//  NavigationViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .clear
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    func clearBackorund() {
        navigationBar.standardAppearance.backgroundColor = .clear
        navigationBar.scrollEdgeAppearance?.backgroundColor = .clear
    }
    
    func blackBackround() {
        navigationBar.standardAppearance.backgroundColor = .background
        navigationBar.scrollEdgeAppearance?.backgroundColor = .background
    }
}
