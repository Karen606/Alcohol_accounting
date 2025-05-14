//
//  Font.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import UIKit

extension UIFont {
    static func poppinsLight(size: CFloat) -> UIFont? {
        return UIFont(name: "Poppins-Light", size: CGFloat(size))
    }

    static func poppinsRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Poppins-Regular.ttf", size: CGFloat(size))
    }
    
    static func poppinsMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Poppins-Medium", size: CGFloat(size))
    }
    
    static func montserratSemiBold(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-SemiBold", size: CGFloat(size))
    }
    
    static func montserratMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: CGFloat(size))
    }
    
    static func montserratRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Regular", size: CGFloat(size))
    }
}
