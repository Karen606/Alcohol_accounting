//
//  ReportViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit
import Combine

class ReportViewController: UIViewController {
    @IBOutlet weak var startDateTextField: BaseTextField!
    @IBOutlet weak var endDateTextField: BaseTextField!
    @IBOutlet weak var generateButton: BaseButton!
    @IBOutlet var reportTitlesLabel: [UILabel]!
    @IBOutlet weak var reportsTableView: UITableView!
    @IBOutlet weak var contentView: ShadowView!
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let viewModel = ReportViewModel.shared
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
        reportTitlesLabel.forEach({ $0.font = .poppinsMedium(size: 15) })
        generateButton.titleLabel?.font = .poppinsRegular(size: 15)
        startDateTextField.setupRightViewIcon(.arrowDown, size: CGSize(width: 40, height: 40))
        endDateTextField.setupRightViewIcon(.arrowDown, size: CGSize(width: 40, height: 40))
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .inline
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
        reportsTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        reportsTableView.delegate = self
        reportsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$reports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reports in
                guard let self = self else { return }
                self.contentView.isHidden = reports.isEmpty
                self.reportsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func startDateChanged() {
        viewModel.startDate = startDatePicker.date
        startDateTextField.text = startDatePicker.date.toString(format: "dd/MM/yy")
    }
    
    @objc func endDateChanged() {
        viewModel.endDate = endDatePicker.date
        endDateTextField.text = endDatePicker.date.toString(format: "dd/MM/yy")
    }

    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedGenerate(_ sender: BaseButton) {
        viewModel.fetchData()
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.configure(quantityChange: viewModel.reports[indexPath.row])
        return cell
    }
}
