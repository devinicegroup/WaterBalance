//
//  UserDefaultsService.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 02.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

enum UserDefaultsServiceEnum: String {
    case lastDateForCheckingOfSuccessfulDays = "LastDateForCheckingOfSuccessfulDays"
    case currentStreak = "CurrentStreak"
    case recordStreak = "RecordStreak"
    case firstDate = "FirstDate"
}

enum UserDefaultsTodayExtension: String {
    case todayDate = "todayDateForTodayExtension"
    case nextDate = "nextDateForTodayExtension"
    case currentVolume = "currentVolumeForTodayExtension"
    case targetVolume = "targetVolumeForTodayExtension"
    case tariningVolume = "tariningVolumeForTodayExtension"
}

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    let defaults = UserDefaults.standard
    private let formatter = DateFormatter()
    
    func setDataForTodayExtension() {
        
    }
    
    func setVolumes() {
        defaults.set(750, forKey: ContainerEnum.decanter.rawValue)
        defaults.set(500, forKey: ContainerEnum.bottle.rawValue)
        defaults.set(400, forKey: ContainerEnum.bigCup.rawValue)
        defaults.set(350, forKey: ContainerEnum.smallCup.rawValue)
        defaults.set(300, forKey: ContainerEnum.jar.rawValue)
        defaults.set(250, forKey: ContainerEnum.glass.rawValue)
        defaults.set(200, forKey: ContainerEnum.jarMini.rawValue)
        defaults.set(150, forKey: ContainerEnum.wineglass.rawValue)
        defaults.set(50, forKey: ContainerEnum.shot.rawValue)
        defaults.set(0, forKey: ContainerEnum.hand.rawValue)
    }
    
    func setSettingsForStart() {
        defaults.set(true, forKey: DateNotificationsEnum.stopNotification.rawValue)
        defaults.set(Date(), forKey: UserDefaultsServiceEnum.firstDate.rawValue)
        
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let lastDateForCheckingOfSuccessfulDays = formatter.string(from: Date())
        defaults.set(lastDateForCheckingOfSuccessfulDays, forKey: UserDefaultsServiceEnum.lastDateForCheckingOfSuccessfulDays.rawValue)
        defaults.set(0, forKey: UserDefaultsServiceEnum.currentStreak.rawValue)
        defaults.set(0, forKey: UserDefaultsServiceEnum.recordStreak.rawValue)
    }
    
    func setDateForNotifications() {
        defaults.set("10:00", forKey: DateNotificationsEnum.startDate.rawValue)
        defaults.set("21:00", forKey: DateNotificationsEnum.endDate.rawValue)
        
        let timeInterval = TimeInterval(90*60)
        defaults.set(timeInterval, forKey: DateNotificationsEnum.dateInterval.rawValue)
    }
}
