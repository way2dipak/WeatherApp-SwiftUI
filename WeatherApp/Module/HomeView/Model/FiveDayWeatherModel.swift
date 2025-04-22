//
//  FiveDayWeatherModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 26/10/23.
//

import Foundation

struct FiveDayWeatherModel: Codable {
    let headline: Headline?
    let dailyForecasts: [DailyForecast]?

    enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case dailyForecasts = "DailyForecasts"
    }
    
    func getForecastLimit(value: Int) -> [DailyForecast]? {
        return dailyForecasts?.prefix(value).map { $0 }
    }
}

// MARK: - DailyForecast
struct DailyForecast: Identifiable, Hashable, Codable {
    let id = UUID()
    let date: String?
    let epochDate: Int?
    let temperature: DailyForecastTemperature?
    let day, night: Day?
    let sources: [String]?
    let mobileLink, link: String?

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case epochDate = "EpochDate"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
        case sources = "Sources"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DailyForecast, rhs: DailyForecast) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getMinTemp() -> Double {
        return temperature?.minimum?.value ?? 0
    }
    
    func getMaxTemp() -> Double {
        return temperature?.maximum?.value ?? 0
    }
    
    var iconLink: String {
        get {
            let iconName = isDayTime ? (day?.icon ?? 1) : (night?.icon ?? 1)
            return "https://openweathermap.org/img/wn/\(openWeatherMappedIcon["\(iconName)"] ?? "01d")@2x.png"
        }
    }
    
    var isToday: Bool {
        get {
            guard let epochDate = epochDate else { return false }
            return epochDate.isToday()
        }
    }
}

// MARK: - Day
struct Day: Codable {
    let icon: Int?
    let iconPhrase: String?
    let hasPrecipitation: Bool?

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
    }
    
}

// MARK: - Temperature
struct DailyForecastTemperature: Codable {
    let minimum, maximum: Imum?

    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

// MARK: - Imum
struct Imum: Codable {
    let value: Double?
    let unit: String?
    let unitType: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
    
    func toCelsius() -> String {
        if let val = value {
            let celsius = (val - 32) * 5/9
            return String(format: "%.1f°", celsius)
        }
        return ""
    }
}


// MARK: - Headline
struct Headline: Codable {
    let effectiveDate: String?
    let effectiveEpochDate, severity: Int?
    let text, category: String?
    let endEpochDate: Int?
    let endDate: String?
    let mobileLink, link: String?

    enum CodingKeys: String, CodingKey {
        case effectiveDate = "EffectiveDate"
        case effectiveEpochDate = "EffectiveEpochDate"
        case severity = "Severity"
        case text = "Text"
        case category = "Category"
        case endDate = "EndDate"
        case endEpochDate = "EndEpochDate"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
}
