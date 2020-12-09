//
//  UIFont + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 27.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func bodyMedium() -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    static func bodyMediumMin1() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    static func bodyMediumMin3() -> UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .medium)
    }
    
    static func bodyRegular() -> UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    static func bodyRegularMin1() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    static func bodyRegularMin2() -> UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .regular)
    }
}
