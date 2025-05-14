//
//  CorrectionViewModel.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import Foundation

class CorrectionViewModel {
    static let shared = CorrectionViewModel()
    var alcoholModel: AlcoholModel?
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        if let id = alcoholModel?.id {
            CoreDataManager.shared.changeAlcoholQuantity(for: id, to: Int64(alcoholModel?.quantity ?? 0), completion: completion)
        }
    }
    
    func clear() {
        alcoholModel = nil
    }
}
