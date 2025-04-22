//
//  Utils.swift
//  WeatherApp
//
//  Created by Dipak Singh on 29/03/25.
//

import Foundation
import SwiftUI

struct Utils {
    static func isApiCallRequired(currentTimeStamp: Int = Date().timestamp,
                           lastTimeStamp: Int) -> Bool {
        let difference = abs(currentTimeStamp - lastTimeStamp)
        switch UpdateFrequency(rawValue: apiFetchIntervalInMins) {
        case .minutes5:
            return difference > 5 * 60
        case .minutes10:
            return difference > 10 * 60
        case .minutes30:
            return difference > 30 * 60
        default:
            return difference > 60 * 60
        }
        
    }
}
