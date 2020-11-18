//
//  String + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 05.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
