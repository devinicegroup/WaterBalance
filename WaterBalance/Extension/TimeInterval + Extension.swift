//
//  TimeInterval + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 28.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

extension TimeInterval {
    var formatted: String {
        let endingDate = Date()
        let startingDate = endingDate.addingTimeInterval(-self)
        let calendar = Calendar.current

        let componentsNow = calendar.dateComponents([.hour, .minute], from: startingDate, to: endingDate)
        if let hour = componentsNow.hour, let minute = componentsNow.minute {
            return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
        } else {
            return "00:00"
        }
    }
}
