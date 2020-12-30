//
//  ChartView.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 21.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import Charts

public class BotttomChartFormatter: NSObject, IAxisValueFormatter {
    var days = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if ChartView.dates.count < 8 {
            return days[Int(value)]
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            let stringDate = dateFormatter.string(from: ChartView.dates[Int(value)])
            return stringDate
        }
    }
}


public class LeftChartFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let left = value / 1000
        return "\(left.rounded(toPlaces: 1)) л"
    }
}

class ChartView: BarChartView {
    
    static var dates: [Date] = []
    
    func setupChartView() {
        self.setScaleEnabled(false)
        self.chartDescription?.enabled = false

        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = false
        self.highlightFullBarEnabled = false
        self.drawBordersEnabled = true
        self.borderColor = .mainWhite()

        let leftAxis = self.leftAxis
        leftAxis.valueFormatter = LeftChartFormatter()
        leftAxis.axisMinimum = 0
        leftAxis.labelCount = 5
        self.rightAxis.enabled = false
        leftAxis.gridColor = .mainLight()
        leftAxis.axisLineColor = .mainLight()
        leftAxis.labelTextColor = .typographySecondary()
        leftAxis.labelFont = .bodyLightMin3()
        
        let xAxis = self.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = BotttomChartFormatter()
        xAxis.granularity = 1
        xAxis.gridColor = .mainLight()
        xAxis.axisLineColor = .mainLight()
        xAxis.labelTextColor = .typographySecondary()
        xAxis.labelFont = .bodyMediumMin3()
        
        self.legend.form = .none
    }
    
    func setChartData(dates: [Date]) {
        var yVals: [BarChartDataEntry] = []
        self.animate(yAxisDuration: 2)
        
        for (index, date) in dates.enumerated() {
            let drinkUps = StorageService.shared.getDataForDay(date: date).first
            var dailyTarget = (StorageService.shared.getDailyTarget(date: date).first?.target ?? 0) + (StorageService.shared.getTraining(date: date).first?.volume ?? 0)
            if dailyTarget == 0 { dailyTarget = UserDefaults.standard.double(forKey: "target") }
            
            var volume = 0.0
            var remaining = 0.0
            
            drinkUps?.forEach({ (drinkUp) in
                volume += drinkUp.hydrationVolume
            })
            
            if dailyTarget >= volume {
                remaining = dailyTarget - volume
            }
            
            //доработать правильное отображение
            if Date.today() < date || date.tomorrow! < UserDefaults.standard.object(forKey: UserDefaultsServiceEnum.firstDate.rawValue) as! Date {
                remaining = 0
            }
            
            let dayData = BarChartDataEntry(x: Double(index), yValues:[volume, remaining])
            yVals.append(dayData)
        }
        
        let set = BarChartDataSet(entries: yVals, label: nil)
        set.drawIconsEnabled = true
        set.colors = [.blue(), .pink()]

        let data = BarChartData(dataSet: set)
        data.setDrawValues(false)
        data.highlightEnabled = false
        
        self.fitBars = true
        self.data = data
    }
}
