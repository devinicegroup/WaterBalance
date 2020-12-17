//
//  AboutApp.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 17.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class AboutApp {
    
    func createSupportMessage() -> String {
        let info = "\n\n\n\n\n----------\nTechnical information: "
        let appName = "App: \(getAppName())"
        let appVersion = "App version: \(getAppInfo())"
        let osVersion = "OS: \(getOSInfo())"
        let modelName = "Device: \(UIDevice.modelName)"
        let technicalInformation = "\(info)\n\(appName)\n\(appVersion)\n\(osVersion)\n\(modelName)"
        return technicalInformation
    }
    
    private func getAppInfo() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    private func getAppName() -> String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        }
    }
    
    private func getOSInfo() -> String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}
