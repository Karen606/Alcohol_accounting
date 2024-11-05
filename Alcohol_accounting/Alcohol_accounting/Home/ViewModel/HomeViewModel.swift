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
        CoreDataManager.shared.updateAlcoholQuantity(for: id, by: 1, completion: completion)
    }
    
    func decrementAlcoholQuantity(for id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updateAlcoholQuantity(for: id, by: -1, completion: completion)
    }
}
