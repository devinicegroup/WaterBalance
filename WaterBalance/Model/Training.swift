//
//  Training.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 16.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import RealmSwift

class Training: Object {
    
    @objc dynamic var volume: Double = 0.0
    @objc dynamic var date: Date = Date()

    convenience init(volume: Double, date: Date) {
        self.init()
        self.volume = volume
        self.date = date
    }
}
