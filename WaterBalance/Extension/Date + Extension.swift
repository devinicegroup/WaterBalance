//
//  Date + Extension.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 12.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

extension Date {
    static func dates(from fromDate: Date?, to toDate: Date?) -> [Date] {
        guard let fromDate = fromDate, let toDate = toDate else { return []}
        
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    static func getDatesForMonth(date: Date) -> [Date] {
        let startDate = date.startOfMonth
        let endDate = date.endOfMonth
        let dates = Date.dates(from: startDate, to: endDate)
        return dates
    }
    
    static func getDatesFor(date: Date, days: Int) -> [Date] {
        let startDate = date
        
        if days >= 0 {
            let endDate = Calendar.current.date(byAdding: .day, value: days - 1, to: date)
            let dates = Date.dates(from: startDate, to: endDate)
            return dates
        } else {
            let endDate = Calendar.current.date(byAdding: .day, value: days + 1, to: date)
            let dates = Date.dates(from: endDate, to: startDate)
            return dates
        }
    }
}

extension Date {
    var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
