//
//  ReportViewModel.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import Foundation

class ReportViewModel {
    static let shared = ReportViewModel()
    @Published var reports: [QuantityChangeModel] = []
    var startDate: Date?
    var endDate: Date?
    
    private init() {}
    
    func fetchData() {
        guard let startDate = startDate, let endDate = endDate else { return }
        CoreDataManager.shared.fetchAllQuantityChanges(from: startDate.stripTime(), to: endDate.stripTime()) { [weak self] reports, _ in
            guard let self = self else { return }
            self.reports = reports
        }
    }
}
