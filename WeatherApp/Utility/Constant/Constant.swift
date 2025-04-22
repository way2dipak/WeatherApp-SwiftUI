//
//  Constant.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import Foundation
import UIKit
import SwiftUI

var kDeviceSize: CGSize {
    return UIScreen.main.bounds.size
}

enum AppStorageKey: String {
    case tempUnits = "tempUnits"
    case windSpeedUnits = "windSpeedUnits"
    case atmosphericPressureUnits = "atmosphericPressureUnits"
    case appLocale = "appLocale"
    case backgroundStyle = "backgroundStyle"
    case dataSavingMode = "dataSavingMode"
    case widgetUpdate = "widgetUpdate"
    case mockData = "mockData"
    case fetchInterval = "fetchInterval"
}

var isDayTime: Bool = true
var apiKey: String = ""
var isMockData: Bool = UserDefaults.standard.bool(forKey: "mockData")
var apiFetchIntervalInMins: String {
    get {
        return UserDefaults.standard.value(forKey: AppStorageKey.fetchInterval.rawValue) as? String ?? ""
    }
}

let windDirectionMap: [String: String] = [
    "N": "North",
    "NNE": "North-Northeast",
    "NE": "Northeast",
    "ENE": "East-Northeast",
    "E": "East",
    "ESE": "East-Southeast",
    "SE": "Southeast",
    "SSE": "South-Southeast",
    "S": "South",
    "SSW": "South-Southwest",
    "SW": "Southwest",
    "WSW": "West-Southwest",
    "W": "West",
    "WNW": "West-Northwest",
    "NW": "Northwest",
    "NNW": "North-Northwest"
]

enum TemperatureUnits: String, Identifiable, CaseIterable {
    case celsius = "celsius (C°)"
    case fahrenheit = "fahrenheit (F°)"
    
    var id: String { self.rawValue }
}

enum WindSpeedUnits: String, Identifiable, CaseIterable {
    case kilometersPerHour = "Kilometers per hour (km/h)"
    case milesPerHour = "Miles per hour (mph)"
    
    var id: String { self.rawValue }
}

enum PressureUnits: String, Identifiable, CaseIterable {
    case millibar = "Millibar (mbar)"
    case inchOfMercury = "Inch of mercury (inHg)"
    
    var id: String { self.rawValue }
}

enum UpdateFrequency: String, Identifiable, CaseIterable {
    case minutes5 = "5 Minutes"
    case minutes10 = "10 Minutes"
    case minutes30 = "30 Minutes"
    case hourly = "Hourly"
    
    var id: String { self.rawValue }
}

enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case hindi = "Hindi"
    
    var id: String { self.rawValue }
    
    var localeShortHand: String {
        switch self {
        case .english:
            return "en-us"
        case .hindi:
            return "hi"
        }
    }
}

enum BackgroundStyle: String, CaseIterable, Identifiable {
    case none = "None"
    case animated = "Animated"
    case gradient = "Gradient"
    
    var id: String { self.rawValue }
}

enum AppThemeStyle: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
    
}


func arcOffset(for value: Double) -> CGSize {
    let clampedValue = max(0.1, min(0.9, value))
    let normalizedValue = (clampedValue - 0.1) / 0.8
    let angle = Angle.degrees(44 + (normalizedValue * 300) + 90)
    
    let radius: CGFloat = 40
    let radians = CGFloat(angle.radians)
    
    return CGSize(
        width: cos(radians) * radius,
        height: sin(radians) * radius
    )
}

func pressureArcOffset(for value: Double) -> CGSize {
    let clampedValue = max(0.1, min(0.9, value))
    let normalizedValue = (clampedValue - 0.1) / 0.8
    let angle = Angle.degrees(44 + (normalizedValue * 300) + 90)
    
    let radius: CGFloat = 40
    let radians = CGFloat(angle.radians)
    
    return CGSize(
        width: cos(radians) * radius,
        height: sin(radians) * radius
    )
}

func whiteToBlackColor(alphaOffset: CGFloat) -> Color {
    let adjustedOffset = pow(alphaOffset, 2.5)
    let colorValue = max(1 - (0.95 * adjustedOffset), 0)
    
    let whiteToBlack = UIColor(
        red: colorValue,
        green: colorValue,
        blue: colorValue,
        alpha: 1
    )
    return Color(whiteToBlack)
}

func blackToWhiteColor(alphaOffset: CGFloat) -> Color {
    let adjustedOffset = pow(alphaOffset, 2.5)
    let opacity = 0.1 + (0.9 * adjustedOffset)
    let colorValue = min(0.05 + (0.95 * adjustedOffset), 1)
    
    let blackToWhite = UIColor(
        red: colorValue,
        green: colorValue,
        blue: colorValue,
        alpha: opacity
    )
    return Color(blackToWhite)
}

func whiteToGrayColor(alphaOffset: CGFloat) -> Color {
    if !isDayTime {
        return .white.opacity(0.1)
    }
    let adjustedOffset = pow(alphaOffset, 2.5)
    let colorValue = max(1 - (0.4 * adjustedOffset), 0.6)
    
    let whiteToGray = UIColor(
        red: colorValue,
        green: colorValue,
        blue: colorValue,
        alpha: 1
    )
    return Color(whiteToGray).opacity(0.5)
}

func interpolatedBackgroundColor(alphaOffset: CGFloat) -> Color {
    if isDayTime {
        return blackToWhiteColor(alphaOffset: alphaOffset)
    }
    return .white.opacity(0.1)
}

func interpolatedTextColor(alphaOffset: CGFloat) -> Color {
    if isDayTime {
        return whiteToBlackColor(alphaOffset: alphaOffset)
    }
    return .white
}

var nightGradientColor: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color.black,
        Color(hex: "#0D0D33")
    ]),
    startPoint: .top,
    endPoint: .bottom
)

var dayGradientColor: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(hex: "#2c67f2"),
        Color(hex: "#62cff4")
    ]),
    startPoint: .top,
    endPoint: .bottom
)
