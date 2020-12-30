//
//  WaterBalanceWidget.swift
//  WaterBalanceWidget
//
//  Created by Sergei Polivanov on 30.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), percent: "0%", currentVolume: "0", targetVolume: "0")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }
    
    func createEntry(id: Int = 1) -> SimpleEntry {
        guard let sharedDefaults = UserDefaults.init(suiteName: "group.forWidget") else {
            return SimpleEntry(date: Date(), percent: "-", currentVolume: "-", targetVolume: "-")
        }
        
        let todayDate = sharedDefaults.object(forKey: UserDefaultsTodayExtension.todayDate.rawValue) as! Date
        let nextDate = sharedDefaults.object(forKey: UserDefaultsTodayExtension.nextDate.rawValue) as! Date
        let currentVolume = sharedDefaults.double(forKey: UserDefaultsTodayExtension.currentVolume.rawValue)
        let targetVolume = sharedDefaults.double(forKey: UserDefaultsTodayExtension.targetVolume.rawValue)
        
        var currentVolumeForEntry: String
        var targetVolumeForEntry: String
        var pepercentForEntry: String
        var date: Date
        if id == 1 {
            currentVolumeForEntry = "\(Int(currentVolume)) мл"
            targetVolumeForEntry = "\(Int(targetVolume)) мл"
            pepercentForEntry = "\(Int(currentVolume / (targetVolume / 100)))%"
            date = todayDate
        } else {
            currentVolumeForEntry = "0 мл"
            targetVolumeForEntry = "\(Int(targetVolume)) мл"
            pepercentForEntry = "0%"
            date = nextDate
        }
        
        let entry = SimpleEntry(date: date, percent: pepercentForEntry, currentVolume: currentVolumeForEntry, targetVolume: targetVolumeForEntry)
        return entry
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let entry1 = createEntry()
        let entry2 = createEntry(id: 2)
        entries.append(entry1)
        entries.append(entry2)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let percent: String
    let currentVolume: String
    let targetVolume: String
}

struct WaterBalanceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(UIColor.white)
            VStack {
                Text(entry.percent)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.typographyLight()))
                    .font(.system(size: 45, weight: .regular))
                    .multilineTextAlignment(.leading)
                Text("Баланс:")
                    .padding(EdgeInsets(top: -8, leading: 16, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.typographySecondary()))
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.leading)
                Text(entry.currentVolume)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.typographyPrimary()))
                    .font(.system(size: 17, weight: .regular))
                    .multilineTextAlignment(.leading)
                Text("Цель:")
                    .padding(EdgeInsets(top: -5, leading: 16, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.typographySecondary()))
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.leading)
                Text(entry.targetVolume)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.typographyPrimary()))
                    .font(.system(size: 17, weight: .regular))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

@main
struct WaterBalanceWidget: Widget {
    let kind: String = "WaterBalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WaterBalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WaterBalance")
        .description("This is a WaterBalance widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct WaterBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        WaterBalanceWidgetEntryView(entry: SimpleEntry(date: Date(), percent: "100%", currentVolume: "1500 мл", targetVolume: "2250 мл"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
