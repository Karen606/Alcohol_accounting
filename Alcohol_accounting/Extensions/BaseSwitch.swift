//
//  BaseSwitch.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 06.11.24.
//


import UIKit

class BaseSwitch: UISwitch {
    override var isOn: Bool {
        didSet {
            self.thumbTintColor = isOn ? .baseDark : #colorLiteral(red: 0.5098039508, green: 0.5098039508, blue: 0.5098039508, alpha: 1)
        }
    }
}
