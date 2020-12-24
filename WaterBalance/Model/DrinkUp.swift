//
//  DrinkUp.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 06.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import RealmSwift

class DrinkUp: Object {
    
    @objc dynamic var volume: Double = 0.0
    @objc dynamic var hydrationVolume: Double = 0.0
    @objc dynamic var caffeine: Double = 0.0
    @objc dynamic var time: Date = Date()
    @objc dynamic var drink: Drink? = nil
    @objc dynamic var id: String = ""
    @objc dynamic var dietaryWaterId: String = ""
    @objc dynamic var dietaryCaffeineId: String = ""
    
    convenience init(volume: Double, hydrationVolume: Double, caffeine: Double, time: Date, drink: Drink, id: String, dietaryWaterId: String, dietaryCaffeineId: String) {
        self.init()
        self.volume = volume
        self.hydrationVolume = hydrationVolume
        self.caffeine = caffeine
        self.time = time
        self.drink = drink
        self.id = id
        self.dietaryWaterId = dietaryWaterId
        self.dietaryCaffeineId = dietaryCaffeineId
    }
}
