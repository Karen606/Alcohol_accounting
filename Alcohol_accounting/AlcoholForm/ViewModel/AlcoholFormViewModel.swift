//
//  AlcoholFormViewModel.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import Foundation

class AlcoholFormViewModel {
    static let shared = AlcoholFormViewModel()
    @Published var alcoholModel = AlcoholModel(id: UUID(), createAt: Date())
    @Published var alcoholTypes: [String] = []
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveAlcohol(alcoholModel: alcoholModel, completion: completion)
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchAlcoholTypes { [weak self] types, _ in
            guard let self = self else { return }
            self.alcoholTypes = types
        }
    }
    
    func clear() {
        alcoholModel = AlcoholModel(id: UUID(), createAt: Date())
    }
}
