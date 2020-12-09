//
//  SettingsData.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 09.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

enum SettingsName: String {
    case rateApp = "Rate App"
    case share = "Share"
    case messageToUs = "Write to us"
    
    case stopNotificationsAfter = "Stop after 100%"
    case stratNotifications = "Start"
    case finishNotifications = "Finish"
    case periodOfNotifications = "Period of notifications"
    
    case appleHealth = "Apple health"
    case sex = "Sex"
    case weight = "Weight"
    case volumes = "Volumes"
    case dailyTarget = "Daily target"
    case training = "Training"
}

enum SettingsNameForUser: String {
    case rateApp = "Оценить приложение"
    case share = "Поделиться"
    case messageToUs = "Написать нам"
    
    case stopNotificationsAfter = "Остановить после 100%"
    case stratNotifications = "Начало"
    case finishNotifications = "Конец"
    case periodOfNotifications = "Интервал"
    
    case appleHealth = "Apple health"
    case sex = "Пол"
    case weight = "Вес"
    case volumes = "Объемы"
    case dailyTarget = "Дневная норма"
    case training = "Тренировка"
}

enum SettingsImageString: String {
    case rateApp = "rate"
    case share = "share"
    case messageToUs = "message"
    
    case stopNotificationsAfter = "stopNotification"
    case stratNotifications = "startNotification"
    case finishNotifications = "endNotification"
    case periodOfNotifications = "intervalNotification"
    
    case appleHealth = "health"
    case sex = "sex"
    case weight = "weight"
    case volumes = "volume"
    case dailyTarget = "target"
    case training = "training"
}

enum SettingsCellType {
    case standard
    case sublabel
    case toggle
    case chevron
}

struct SettingsModel {
    let name: String
    let nameForUser: String
    let imageString: String
    let type: SettingsCellType
    let id: Int
    let subtitle: String?
    let toggle: Bool?
}

struct Settings {
    lazy var settingsData: [[SettingsModel]] = [aboutApplication, notifications, settings]
    lazy var headerTitles = ["О приложении", "Уведомления", "Настройки"]
    
    private let aboutApplication = [
        SettingsModel(name: SettingsName.rateApp.rawValue,
                     nameForUser: SettingsNameForUser.rateApp.rawValue,
                     imageString: SettingsImageString.rateApp.rawValue,
                     type: .standard,
                     id: 0,
                     subtitle: nil,
                     toggle: nil),
        SettingsModel(name: SettingsName.share.rawValue,
                     nameForUser: SettingsNameForUser.share.rawValue,
                     imageString: SettingsImageString.share.rawValue,
                     type: .standard,
                     id: 1,
                     subtitle: nil,
                     toggle: nil),
        SettingsModel(name: SettingsName.messageToUs.rawValue,
                     nameForUser: SettingsNameForUser.messageToUs.rawValue,
                     imageString: SettingsImageString.messageToUs.rawValue,
                     type: .standard,
                     id: 2,
                     subtitle: nil,
                     toggle: nil)
    ]
    
    private let notifications = [
        SettingsModel(name: SettingsName.stopNotificationsAfter.rawValue,
                     nameForUser: SettingsNameForUser.stopNotificationsAfter.rawValue,
                     imageString: SettingsImageString.stopNotificationsAfter.rawValue,
                     type: .toggle,
                     id: 3,
                     subtitle: nil,
                     toggle: true),
        SettingsModel(name: SettingsName.stratNotifications.rawValue,
                     nameForUser: SettingsNameForUser.stratNotifications.rawValue,
                     imageString: SettingsImageString.stratNotifications.rawValue,
                     type: .sublabel,
                     id: 4,
                     subtitle: "123",
                     toggle: nil),
        SettingsModel(name: SettingsName.finishNotifications.rawValue,
                     nameForUser: SettingsNameForUser.finishNotifications.rawValue,
                     imageString: SettingsImageString.finishNotifications.rawValue,
                     type: .sublabel,
                     id: 5,
                     subtitle: "123",
                     toggle: nil),
        SettingsModel(name: SettingsName.periodOfNotifications.rawValue,
                     nameForUser: SettingsNameForUser.periodOfNotifications.rawValue,
                     imageString: SettingsImageString.periodOfNotifications.rawValue,
                     type: .sublabel,
                     id: 6,
                     subtitle: "123",
                     toggle: nil)
    ]
    
    private let settings = [
        SettingsModel(name: SettingsName.appleHealth.rawValue,
                     nameForUser: SettingsNameForUser.appleHealth.rawValue,
                     imageString: SettingsImageString.appleHealth.rawValue,
                     type: .toggle,
                     id: 7,
                     subtitle: nil,
                     toggle: true),
        SettingsModel(name: SettingsName.sex.rawValue,
                     nameForUser: SettingsNameForUser.sex.rawValue,
                     imageString: SettingsImageString.sex.rawValue,
                     type: .sublabel,
                     id: 8,
                     subtitle: "456",
                     toggle: nil),
        SettingsModel(name: SettingsName.weight.rawValue,
                     nameForUser: SettingsNameForUser.weight.rawValue,
                     imageString: SettingsImageString.weight.rawValue,
                     type: .sublabel,
                     id: 9,
                     subtitle: "456",
                     toggle: nil),
        SettingsModel(name: SettingsName.volumes.rawValue,
                     nameForUser: SettingsNameForUser.volumes.rawValue,
                     imageString: SettingsImageString.volumes.rawValue,
                     type: .chevron,
                     id: 10,
                     subtitle: nil,
                     toggle: nil),
        SettingsModel(name: SettingsName.dailyTarget.rawValue,
                     nameForUser: SettingsNameForUser.dailyTarget.rawValue,
                     imageString: SettingsImageString.dailyTarget.rawValue,
                     type: .sublabel,
                     id: 11,
                     subtitle: "456",
                     toggle: nil),
        SettingsModel(name: SettingsName.training.rawValue,
                     nameForUser: SettingsNameForUser.training.rawValue,
                     imageString: SettingsImageString.training.rawValue,
                     type: .sublabel,
                     id: 12,
                     subtitle: "456",
                     toggle: nil),
    ]
}
