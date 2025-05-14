//
//  Date.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//


import Foundation

extension Date {
    func toString(format: String = "dd/MM/yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func stripTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
