//
//  Double + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 21.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
