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
    let healthKitStore = HKHealthStore()
    
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
        let healthKitTypesToRead: Set<HKObjectType> = [biologicalSex, bodyMass, dietaryWater, dietaryCaffeine]
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    func getSex() throws -> (HKBiologicalSex) {
        do {
            let biologicalSex = try healthKitStore.biologicalSex()
            let unwrappedBiologicalSex = biologicalSex.biologicalSex
            return (unwrappedBiologicalSex)
        }
    }
    
    func getSample(for sampleType: HKSampleType, with predicate: NSPredicate, completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        
        //1. Используйте HKQuery для загрузки последних образцов.
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: predicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            //2. Всегда отправляйте в основной поток по завершении.
            DispatchQueue.main.async {
                guard let samples = samples,
                      let mostRecentSample = samples.first as? HKQuantitySample else {
                    completion(nil, error)
                    return
                }
                completion(mostRecentSample, nil)
            }
        }
        HKHealthStore().execute(sampleQuery)
    }
    
    func deleteSample(object: HKSample) {
        healthKitStore.delete(object) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteSamples(drinkUp: DrinkUp) {
        guard let dietaryWaterSampleType = HKSampleType.quantityType(forIdentifier: .dietaryWater),
              let dietaryCaffeineSampleType = HKSampleType.quantityType(forIdentifier: .dietaryCaffeine) else { return }
        
        let ids = [drinkUp.dietaryWaterId, drinkUp.dietaryCaffeineId]
        let samplesType = [dietaryWaterSampleType, dietaryCaffeineSampleType]
        
        for (index, id) in ids.enumerated() {
            if let uuid = UUID(uuidString: id) {
                let predicate = HealthService.shared.createPredicate(id: uuid)
                HealthService.shared.getSample(for: samplesType[index], with: predicate) { (sample, error) in
                    guard let sample = sample else {
                        print(error?.localizedDescription ?? "error deleteDrinkUp")
                        return
                    }
                    HealthService.shared.deleteSample(object: sample)
                }
            }
        }
    }
    
    func saveDietaryWaterSample(volume: Double, date: Date, completion: @escaping (UUID?) -> Void) {
        guard let dietaryWaterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else { return }
        
        let quanitytUnit = HKUnit(from: "ml")
        let dietaryWaterQuantity = HKQuantity(unit: quanitytUnit, doubleValue: volume)
        let dietaryWaterSample = HKQuantitySample(type: dietaryWaterType,
                                                  quantity: dietaryWaterQuantity,
                                                  start: date,
                                                  end: date)
        
        HKHealthStore().save(dietaryWaterSample) { (success, error) in
            if let error = error {
                completion(nil)
                print(error.localizedDescription)
            }
            if success {
                completion(dietaryWaterSample.uuid)
            }
        }
    }
    
    func saveDietaryCaffeineSample(mg: Double, date: Date, completion: @escaping (UUID?) -> Void) {
        guard let dietaryCaffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine) else { return }
        
        let quanitytUnit = HKUnit(from: "mg")
        let dietaryCaffeineQuantity = HKQuantity(unit: quanitytUnit, doubleValue: mg)
        let dietaryCaffeineSample = HKQuantitySample(type: dietaryCaffeineType,
                                                     quantity: dietaryCaffeineQuantity,
                                                     start: date,
                                                     end: date)
        
        HKHealthStore().save(dietaryCaffeineSample) { (success, error) in
            if let error = error {
                completion(nil)
                print(error.localizedDescription)
            }
            if success {
                completion(dietaryCaffeineSample.uuid)
            }
        }
    }
    
    func saveBodyMassSample(kg: Double, date: Date) {
        guard let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }
        
        let quanitytUnit = HKUnit(from: "kg")
        let bodyMassQuantity = HKQuantity(unit: quanitytUnit, doubleValue: kg)
        let bodyMassSample = HKQuantitySample(type: bodyMassType,
                                              quantity: bodyMassQuantity,
                                              start: date,
                                              end: date)
        
        HKHealthStore().save(bodyMassSample) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func createPredicate(start: Date, end: Date, options: HKQueryOptions) -> NSPredicate {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: options)
        return predicate
    }
    
    func createPredicate(id: UUID) -> NSPredicate {
        let predicate = HKQuery.predicateForObject(with: id)
        return predicate
    }
}
