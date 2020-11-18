//
//  DailyTarget.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 17.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import RealmSwift

class DailyTarget: Object {
    
    @objc dynamic var target: Double = 0.0
    @objc dynamic var date: Date = Date()

    convenience init(target: Double, date: Date) {
        self.init()
        self.target = target
        self.date = date
    }
}
