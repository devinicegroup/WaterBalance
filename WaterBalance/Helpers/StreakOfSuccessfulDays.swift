//
//  StreakOfSuccessfulDays.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 18.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import RealmSwift

class StreakOfSuccessfulDays {
    
    static let shared = StreakOfSuccessfulDays()
    
    private let formatter = DateFormatter()
    
    init() {
        formatter.timeStyle = .none
        formatter.dateStyle = .long
    }

    func checkingStreaks() {
        guard let lastDateString = UserDefaults.standard.string(forKey: UserDefaultsServiceEnum.lastDateForCheckingOfSuccessfulDays.rawValue) else { return }
        guard let lastDate = formatter.date(from: lastDateString) else { return }
        guard let today = Date().removeTimeStamp else { return }
        guard let lastTodayDate = lastDate.tomorrow else { return }
        var currentStreak = UserDefaults.standard.integer(forKey: UserDefaultsServiceEnum.currentStreak.rawValue)
        var recordStreak = UserDefaults.standard.integer(forKey: UserDefaultsServiceEnum.recordStreak.rawValue)
        
        if lastTodayDate == today {
            guard let lastDrinkUp = StorageService.shared.getDataForDay(date: lastDate).first else { return }
            var volume = 0.0
            lastDrinkUp.forEach { (drinkUp) in
                volume += drinkUp.hydrationVolume
            }

            let targetVolume = UserDefaults.standard.double(forKey: "target")
            if volume >= targetVolume {
                currentStreak += 1
                UserDefaults.standard.set(currentStreak, forKey: UserDefaultsServiceEnum.currentStreak.rawValue)
                if currentStreak > recordStreak {
                    print("Current streak: \(currentStreak)")
                    print("Record streak: \(recordStreak)")
                    recordStreak = currentStreak
                    UserDefaults.standard.set(recordStreak, forKey: UserDefaultsServiceEnum.recordStreak.rawValue)
                    print("Current streak: \(currentStreak)")
                    print("Record streak: \(recordStreak)")
                }
            } else {
                UserDefaults.standard.set(0, forKey: UserDefaultsServiceEnum.currentStreak.rawValue)
            }
        } else if lastTodayDate < today {
            UserDefaults.standard.set(0, forKey: UserDefaultsServiceEnum.currentStreak.rawValue)
            NotificationService.shared.createNotification()
        }
        
        let lastDateForCheckingOfSuccessfulDays = formatter.string(from: Date())
        UserDefaults.standard.set(lastDateForCheckingOfSuccessfulDays, forKey: UserDefaultsServiceEnum.lastDateForCheckingOfSuccessfulDays.rawValue)
    }
}
