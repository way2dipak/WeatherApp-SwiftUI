//
//  Extension.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import Foundation

extension Double {
    func roundeValue() -> String {
        let roundedValue = self.rounded()
        return String(format: "%.0f", roundedValue)
    }
    
    func fahrenheitToCelsius() -> Double {
        return (self - 32) * 5 / 9
    }
    
}

extension Int {
    func convertToWeekName() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            // Get the weekday name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"  // This gives the full name of the weekday
            return dateFormatter.string(from: date)
        }
    }
    
    func isToday() -> Bool {
            let date = Date(timeIntervalSince1970: TimeInterval(self))
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }
    
}

extension Date {
    var timestamp: Int {
        return Int(self.timeIntervalSince1970)
    }
}
