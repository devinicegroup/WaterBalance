//
//  UserDefaultsServiceForWidget.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 30.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

enum UserDefaultsTodayExtension: String {
    case todayDate = "todayDateForTodayExtension"
    case nextDate = "nextDateForTodayExtension"
    case currentVolume = "currentVolumeForTodayExtension"
    case targetVolume = "targetVolumeForTodayExtension"
}

class UserDefaultsServiceForWidget {
    
    static let shared = UserDefaultsServiceForWidget()
    
    func setDataForTodayExtension(currentVolume: Double, targetVolume: Double, tariningVolume: Double) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.forWidget") else { return }
        
        sharedDefaults.set(Date(), forKey: UserDefaultsTodayExtension.todayDate.rawValue)
        sharedDefaults.set(Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: Calendar.autoupdatingCurrent.startOfDay(for: Date()))!, forKey: UserDefaultsTodayExtension.nextDate.rawValue)
        sharedDefaults.set(currentVolume, forKey: UserDefaultsTodayExtension.currentVolume.rawValue)
        sharedDefaults.set(targetVolume, forKey: UserDefaultsTodayExtension.targetVolume.rawValue)
    }
    
    func setDataForTodayExtension(volume: Double?, targetVolume: Double?) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.forWidget") else { return }
        
        sharedDefaults.set(Date(), forKey: UserDefaultsTodayExtension.todayDate.rawValue)
        sharedDefaults.set(Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: Calendar.autoupdatingCurrent.startOfDay(for: Date()))!, forKey: UserDefaultsTodayExtension.nextDate.rawValue)
        
        if volume != nil {
            let newVolume = sharedDefaults.double(forKey: UserDefaultsTodayExtension.currentVolume.rawValue) + volume!
            sharedDefaults.set(newVolume, forKey: UserDefaultsTodayExtension.currentVolume.rawValue)
        }
        
        if targetVolume != nil {
            sharedDefaults.set(targetVolume, forKey: UserDefaultsTodayExtension.targetVolume.rawValue)
        }
    }
}
