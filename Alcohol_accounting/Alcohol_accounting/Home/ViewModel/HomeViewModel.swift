//
//  HomeViewModel.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    @Published var alcohols: [AlcoholModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchAlcohols { [weak self] alcohols, _ in
            guard let self = self else { return }
            self.alcohols = alcohols
        }
    }
    
    func incrementAlcoholQuantity(for id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updateAlcoholQuantity(for: id, by: 1) { model, error in
            if let model = model, (model.quantity ?? 0) < 3 {
                let title = "Low Stock Alert"
                let body = "\(model.name ?? "Alcohol") quantity is low (\(model.quantity ?? 0))."
                let date = Date().addingTimeInterval(5)  // Set notification for 5 seconds later, adjust as needed
                NotificationManager.shared.scheduleNotification(for: date, title: title, body: body)
            }
            completion(error)
        }
    }
    
    func decrementAlcoholQuantity(for id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updateAlcoholQuantity(for: id, by: -1) { model, error in
            if let model = model, (model.quantity ?? 0) < 3 {
                let title = "Low Stock Alert"
                let body = "\(model.name ?? "Alcohol") quantity is low (\(model.quantity ?? 0))."
                let date = Date().addingTimeInterval(5)  // Set notification for 5 seconds later, adjust as needed
                NotificationManager.shared.scheduleNotification(for: date, title: title, body: body)
            }
            completion(error)
        }
    }
}
