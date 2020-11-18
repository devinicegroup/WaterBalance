//
//  StorageService.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 06.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageService {
    
    static let shared = StorageService()
    
    func saveDrink(drink: Drink) {
        try! realm.write {
            realm.add(drink)
        }
    }
    
    func saveDrinkUp(drinkUp: DrinkUp) {
        try! realm.write {
            realm.add(drinkUp)
        }
    }
    
    func saveDailyTarget(dailyTarget: DailyTarget) {
        try! realm.write {
            realm.add(dailyTarget)
        }
    }
    
    func getDataForMonth(date: Date) -> [Results<DrinkUp>] {
        var drinkUps = [Results<DrinkUp>]()
        let dates = Date.getDate(date: date)
        dates.forEach { (date) in
            let todayStart = Calendar.current.startOfDay(for: date)
            let todayEnd: Date = {
                let components = DateComponents(day: 1, second: -1)
                return Calendar.current.date(byAdding: components, to: todayStart)!
            }()
            drinkUps.append(realm.objects(DrinkUp.self).filter("time BETWEEN %@", [todayStart, todayEnd]).sorted(byKeyPath: "time", ascending: false))
        }
        return drinkUps
    }
    
    func getDataForDay(date: Date) -> [Results<DrinkUp>] {
        var drinkUps = [Results<DrinkUp>]()
        let todayStart = Calendar.current.startOfDay(for: date)
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        drinkUps.append(realm.objects(DrinkUp.self).filter("time BETWEEN %@", [todayStart, todayEnd]).sorted(byKeyPath: "time", ascending: false))
        return drinkUps
    }
    
    func getDailyTarget(date: Date) -> Results<DailyTarget> {
        let todayStart = Calendar.current.startOfDay(for: date)
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        let dailyTarget = realm.objects(DailyTarget.self).filter("date BETWEEN %@", [todayStart, todayEnd])
        return dailyTarget
    }
    
    func updateDrink(drinkUp: DrinkUp, drink: Drink) {
        try! realm.write {
            drinkUp.drink = drink
            drinkUp.hydrationVolume = drinkUp.volume * drink.hydration
            drinkUp.caffeine = drinkUp.volume * drink.caffeine
        }
    }
    
    func updateDate(drinkUp: DrinkUp, date: Date) {
        try! realm.write {
            drinkUp.time = date
        }
    }
    
    func updateVolume(drinkUp: DrinkUp, volume: Double) {
        try! realm.write {
            drinkUp.volume = volume
            drinkUp.hydrationVolume = drinkUp.volume * drinkUp.drink!.hydration
            drinkUp.caffeine = drinkUp.volume * drinkUp.drink!.caffeine
        }
    }
}
