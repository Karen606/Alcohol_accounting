//
//  CoreDataManager.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//


import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Alcohol_accounting")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveAlcohol(alcoholModel: AlcoholModel, completion: @escaping (Error?) -> Void) {
        let id = alcoholModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Alcohol> = Alcohol.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let alcohol: Alcohol
                
                if let existingAlcohol = results.first {
                    alcohol = existingAlcohol
                } else {
                    alcohol = Alcohol(context: backgroundContext)
                    alcohol.id = id
                }
                alcohol.createAt = alcoholModel.createAt
                alcohol.name = alcoholModel.name
                alcohol.quantity = Int64(alcoholModel.quantity ?? 0)
                alcohol.type = alcoholModel.type
                alcohol.volume = alcoholModel.volume ?? 0
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchAlcohols(completion: @escaping ([AlcoholModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Alcohol> = Alcohol.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var alcoholsModel: [AlcoholModel] = []
                for result in results {
                    let alcoholModel = AlcoholModel(id: result.id, createAt: result.createAt, name: result.name, type: result.type, volume: result.volume, quantity: Int(result.quantity))
                    alcoholsModel.append(alcoholModel)
                }
                completion(alcoholsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func setupDefaultAlcoholTypes() {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<AlcoholType> = AlcoholType.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if results.isEmpty {
                    let alcoholType = AlcoholType(context: backgroundContext)
                    alcoholType.types = ["Whiskey", "Vodka", "Beer", "Wine"]
                    try backgroundContext.save()
                }
            } catch {
                print("Failed to fetch or create AlcoholType:", error)
            }
        }
    }
    
    func fetchAlcoholTypes(completion: @escaping ([String], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<AlcoholType> = AlcoholType.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let alcoholType = results.first {
                    let types = alcoholType.types ?? []
                    completion(types, nil)
                } else {
                    completion([], nil)
                }
            } catch {
                completion([], error)
            }
        }
    }
    
    func updateAlcoholQuantity(for id: UUID, by amount: Int64, completion: @escaping (AlcoholModel?, Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Alcohol> = Alcohol.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let alcohol = try backgroundContext.fetch(fetchRequest).first {
                    alcohol.quantity += amount
                    if alcohol.quantity < 0 {
                        alcohol.quantity = 0
                    }
                    
                    
                    let quantityChange = QuantityChange(context: backgroundContext)
                    quantityChange.id = UUID()
                    quantityChange.date = Date().stripTime()
                    quantityChange.amount = amount
                    let name = alcohol.name
                    quantityChange.name = name // Link to the alcohol record
                    
                    // Save changes
                    try backgroundContext.save()
                    
                    let updatedAlcoholModel = AlcoholModel(
                        id: alcohol.id,
                        createAt: alcohol.createAt,
                        name: alcohol.name,
                        type: alcohol.type,
                        volume: alcohol.volume,
                        quantity: Int(alcohol.quantity)
                    )
                    
                    DispatchQueue.main.async {
                        completion(updatedAlcoholModel, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Alcohol not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    func changeAlcoholQuantity(for id: UUID, to newQuantity: Int64, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Alcohol> = Alcohol.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let alcohol = try backgroundContext.fetch(fetchRequest).first {
                    let previousQuantity = alcohol.quantity
                    let changeAmount = newQuantity - previousQuantity
                    alcohol.quantity = newQuantity
                    
                    // Ensure quantity doesn't go below zero
                    if alcohol.quantity < 0 {
                        alcohol.quantity = 0
                    }
                    
                    let quantityChange = QuantityChange(context: backgroundContext)
                    quantityChange.id = UUID()
                    quantityChange.date = Date().stripTime()
                    quantityChange.amount = changeAmount
                    quantityChange.name = alcohol.name
                    // Save both alcohol and quantity change
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Alcohol not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveAlcohol(quantityChangeModel: QuantityChangeModel, completion: @escaping (Error?) -> Void) {
        let id = quantityChangeModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<QuantityChange> = QuantityChange.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let quantityChange: QuantityChange
                
                if let existingquantityChange = results.first {
                    quantityChange = existingquantityChange
                } else {
                    quantityChange = QuantityChange(context: backgroundContext)
                    quantityChange.id = id
                }
                quantityChange.name = quantityChangeModel.name
                quantityChange.amount = Int64(quantityChangeModel.amount ?? 0)
                quantityChange.date = Date().stripTime()
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchAllQuantityChanges(from startDate: Date, to endDate: Date, completion: @escaping ([QuantityChangeModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<QuantityChange> = QuantityChange.fetchRequest()
            
            // Predicate to filter quantity changes by date range
            let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
            fetchRequest.predicate = datePredicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                
                // Convert results to an array of QuantityChangeModel for easier handling
                let changes = results.map {
                    QuantityChangeModel(id: $0.id, date: $0.date, amount: Int($0.amount), name: $0.name)
                }
                
                // Return results on the main thread
                DispatchQueue.main.async {
                    completion(changes, nil)
                }
            } catch {
                // Handle fetch error
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }


}

