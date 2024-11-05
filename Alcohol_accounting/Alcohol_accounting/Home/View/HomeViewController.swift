//
//  HomeViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alcoholsTableView: UITableView!
    private let viewModel = HomeViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func setupUI() {
        titleLabel.font = .montserratMedium(size: 28)
        alcoholsTableView.roundCorners([.topLeft, .topRight], radius: 20)
        alcoholsTableView.register(UINib(nibName: "AlcoholTableViewCell", bundle: nil), forCellReuseIdentifier: "AlcoholTableViewCell")
        alcoholsTableView.delegate = self
        alcoholsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$alcohols
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alcohols in
                guard let self = self else { return }
                self.alcoholsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.alcohols.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlcoholTableViewCell", for: indexPath) as! AlcoholTableViewCell
        cell.configure(alcohol: viewModel.alcohols[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return (section == 0) ? UIView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 40 : 0
    }
}

extension HomeViewController: AlcoholTabelViewCellDelegate {
    func increment(by id: UUID) {
        viewModel.incrementAlcoholQuantity(for: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
    
    func decrement(by id: UUID) {
        viewModel.decrementAlcoholQuantity(for: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
}
