//
//  Drink.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 06.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import RealmSwift

class Drink: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var nameForUser: String = ""
    @objc dynamic var imageString: String = ""
    @objc dynamic var hydration: Double = 0.0
    @objc dynamic var caffeine: Double = 0.0
    @objc dynamic var id: Int = 0
    
    convenience init(name: String, nameForUser: String, imageString: String, hydration: Double, caffeine: Double, id: Int) {
        self.init()
        self.name = name
        self.nameForUser = nameForUser
        self.imageString = imageString
        self.hydration = hydration
        self.caffeine = caffeine
        self.id = id
    }

    static func saveDrinkables() {
        for drink in DrinkStart.drinkables {
            let newDrink = Drink(name: drink.name, nameForUser: drink.nameForUser, imageString: drink.imageString, hydration: drink.hydration, caffeine: drink.caffeine, id: drink.id)
            StorageService.shared.saveDrink(drink: newDrink)
        }
    }
}
