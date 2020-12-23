//
//  HealthService.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 23.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit
import HealthKit

class HealthService {
    
    static let shared = HealthService()
//    let healthKitStore = HKHealthStore()
    
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthkitSetupError.notAvailableOnDevice)
          return
        }
        
        guard let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
              let dietaryWater = HKObjectType.quantityType(forIdentifier: .dietaryWater),
              let dietaryCaffeine = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMass, dietaryWater, dietaryCaffeine]
        //Возможно удалить из массива dietaryWater, dietaryCaffeine (если это не потребуется при удалении или редактировании записи)
        let healthKitTypesToRead: Set<HKObjectType> = [biologicalSex, bodyMass, dietaryWater, dietaryCaffeine]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
