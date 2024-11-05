//
//  HomeViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alcoholsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.font = .montserratMedium(size: 28)
        alcoholsTableView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    

}
