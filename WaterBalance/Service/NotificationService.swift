//
//  NotificationService.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 28.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationService: NSObject {
    
    static let shared = NotificationService()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dateFormatter = DateFormatter()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (success, error) in
            guard success else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func removeNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
//        notificationCenter.getPendingNotificationRequests { (notifications) in
//            for notification in notifications {
//                print(notification.identifier)
//            }
//        }
    }
    
    func createNotification() {
        removeNotification()
        guard var startDate = getStartDate() else { return }
        guard var endDate = getEndDate(startDate: startDate) else { return }
        let timeInterval = TimeInterval(UserDefaults.standard.double(forKey: DateNotificationsEnum.dateInterval.rawValue))
        var dateNotification = Date(timeIntervalSinceNow: timeInterval)
        
        for _ in 0..<64 {
            scheduleNotification(date: dateNotification)
            
            dateNotification = dateNotification + timeInterval
            
            if dateNotification > endDate {
                startDate = startDate.tomorrow!
                endDate = endDate.tomorrow!
                dateNotification = startDate
            }
        }
    }
    
    func scheduleNotification(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Время выпить воды"
        content.body = "Вы давно не употребляли жидкость"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationID = createNotificationID(date: date)
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func createNotificationID(date: Date) -> String {
        dateFormatter.dateFormat = "dd.MM HH:mm"
        let dateForId = dateFormatter.string(from: date)
        let notificationID = "Local Notification \(dateForId)"
        return notificationID
    }
    
    private func getStartDate() -> Date? {
        dateFormatter.dateFormat = "HH:mm"
        
        guard let stringStartTime = UserDefaults.standard.string(forKey: DateNotificationsEnum.startDate.rawValue),
              let startTime = dateFormatter.date(from: stringStartTime) else { return nil }
        
        let startDate = combineDateWithTime(date: Date(), time: startTime)
        return startDate
    }
    
    private func getEndDate(startDate: Date) -> Date? {
        dateFormatter.dateFormat = "HH:mm"
        
        guard let stringEndTime = UserDefaults.standard.string(forKey: DateNotificationsEnum.endDate.rawValue),
              let endTime = dateFormatter.date(from: stringEndTime) else { return nil }
        
        guard let endDate = combineDateWithTime(date: Date(), time: endTime) else { return nil}
        return endDate > startDate ? endDate : endDate.tomorrow
    }
    
    private func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        
        return calendar.date(from: mergedComponments)
    }
}


//MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
