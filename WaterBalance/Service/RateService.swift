//
//  RateService.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 10.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import StoreKit

class RateService {
    
    private static let targetRunCount = 5
    
    class func incrementCount() {
        let count = UserDefaults.standard.integer(forKey: "runCount")
        
        if count < targetRunCount {
            UserDefaults.standard.set(count + 1, forKey: "runCount")
        }
    }
    
    class func showRatesController(delay: Bool = true) {
        let count = UserDefaults.standard.integer(forKey: "runCount")
        
        if !delay {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
        } else {
            if count == targetRunCount {
                UserDefaults.standard.set(targetRunCount + 1, forKey: "runCount")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
}
