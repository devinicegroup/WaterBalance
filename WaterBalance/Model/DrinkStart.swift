//
//  DrinkStart.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 27.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

struct DrinkStart: Hashable {
    
    var name: String
    var nameForUser: String
    var imageString: String
    var hydration: Double
    var caffeine: Double
    var id: Int
    
    static var drinkables = [
        DrinkStart(name: "Water", nameForUser: "Вода", imageString: "water", hydration: 1.0, caffeine: 0, id: 0),
        DrinkStart(name: "Mineral Water", nameForUser: "Минералка", imageString: "mineralWater", hydration: 1.0, caffeine: 0, id: 1),
        DrinkStart(name: "Coffee", nameForUser: "Кофе", imageString: "coffee", hydration: 0.8, caffeine: 0.7, id: 2),
        DrinkStart(name: "Decaffeinated coffee", nameForUser: "Кофе без кофеина", imageString: "decaffeinatedCoffee", hydration: 0.8, caffeine: 0.03, id: 3),
        DrinkStart(name: "Cocoa", nameForUser: "Какао", imageString: "cocoa", hydration: 0.7, caffeine: 0.05, id: 4),
        DrinkStart(name: "Hot chocolate", nameForUser: "Горячий шоколад", imageString: "hotChocolate", hydration: 0.45, caffeine: 0.19, id: 5),
        DrinkStart(name: "Black tea", nameForUser: "Черный чай", imageString: "blackTea", hydration: 0.85, caffeine: 0.45, id: 6),
        DrinkStart(name: "Green tea", nameForUser: "Зеленый чай", imageString: "greenTea", hydration: 0.9, caffeine: 0.5, id: 7),
        DrinkStart(name: "Herb tea", nameForUser: "Травяной чай", imageString: "herbTea", hydration: 0.95, caffeine: 0, id: 8),
        DrinkStart(name: "Milk", nameForUser: "Молоко", imageString: "milk", hydration: 0.82, caffeine: 0, id: 9),
        DrinkStart(name: "Kefir", nameForUser: "Кефир", imageString: "kefir", hydration: 0.65, caffeine: 0, id: 10),
        DrinkStart(name: "Yogurt", nameForUser: "Йогурт", imageString: "yogurt", hydration: 0.5, caffeine: 0, id: 11),
        DrinkStart(name: "Sports drink", nameForUser: "Спортивный напиток", imageString: "sportsDrink", hydration: 0.83, caffeine: 0, id: 12),
        DrinkStart(name: "Coconut water", nameForUser: "Кокосовая вода", imageString: "coconutWater", hydration: 0.85, caffeine: 0, id: 13),
        DrinkStart(name: "Soda", nameForUser: "Газировка", imageString: "soda", hydration: 0.68, caffeine: 0.03, id: 14),
        DrinkStart(name: "Diet soda", nameForUser: "Газировка диет.", imageString: "dietSoda", hydration: 0.75, caffeine: 0.03, id: 15),
        DrinkStart(name: "Power engineer", nameForUser: "Энергетик", imageString: "powerEngineer", hydration: 0.45, caffeine: 0.65, id: 16),
        DrinkStart(name: "Lemonade", nameForUser: "Лимонад", imageString: "lemonade", hydration: 0.75, caffeine: 0, id: 17),
        DrinkStart(name: "Compote", nameForUser: "Компот", imageString: "compote", hydration: 0.9, caffeine: 0, id: 18),
        DrinkStart(name: "Juice", nameForUser: "Сок", imageString: "juice", hydration: 0.89, caffeine: 0, id: 19),
        DrinkStart(name: "Smoothie", nameForUser: "Смузи", imageString: "smoothie", hydration: 0.7, caffeine: 0, id: 20),
        DrinkStart(name: "Milkshake", nameForUser: "Милкшейк", imageString: "milkshake", hydration: 0.66, caffeine: 0, id: 21),
        DrinkStart(name: "Wine", nameForUser: "Вино", imageString: "wine", hydration: -1.4, caffeine: 0, id: 22),
        DrinkStart(name: "Beer", nameForUser: "Пиво", imageString: "beer", hydration: -0.35, caffeine: 0, id: 23),
        DrinkStart(name: "Cocktail", nameForUser: "Алк. коктейль", imageString: "cocktail", hydration: -1.8, caffeine: 0, id: 24),
        DrinkStart(name: "Champagne", nameForUser: "Шампанское", imageString: "champagne", hydration: -1.5, caffeine: 0, id: 25),
        DrinkStart(name: "Whiskey", nameForUser: "Крепкий алк.", imageString: "whiskey", hydration: -3.5, caffeine: 0, id: 26),
        DrinkStart(name: "Absinthe", nameForUser: "Абсент", imageString: "absinthe", hydration: -5, caffeine: 0, id: 27)
    ]
}
