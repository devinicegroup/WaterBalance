//
//  HKBiologicalSex+StringRepresentation.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 24.12.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation
import HealthKit

enum BiologicalSex: String, CaseIterable {
  case male = "Мужской"
  case female = "Женский"
}

extension HKBiologicalSex {
  var stringRepresentation: String {
    switch self {
    case .notSet: return ""
    case .female: return BiologicalSex.female.rawValue
    case .male: return BiologicalSex.male.rawValue
    case .other: return ""
    @unknown default:
        return ""
    }
  }
}
