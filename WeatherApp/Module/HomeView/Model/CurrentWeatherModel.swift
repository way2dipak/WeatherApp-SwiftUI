//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 11/10/23.
//

import Foundation

// MARK: - CurrentWeatherModel
struct CurrentWeatherModel: Codable {
    let epochTime: Int?
    let weatherText: String?
    let weatherIcon: Int?
    let hasPrecipitation: Bool?
    let precipitationType: String?
    let isDayTime: Bool?
    let temperature, realFeelTemperature, realFeelTemperatureShade: Temperature?
    let relativeHumidity, indoorRelativeHumidity: Int?
    let dewPoint: Temperature?
    let wind: Wind?
    let windGust: WindGust?
    let uvIndex: Int?
    let uvIndexText: String?
    let visibility: Temperature?
    let obstructionsToVisibility: String?
    let cloudCover: Int?
    let ceiling, pressure: Temperature?
    let pressureTendency: PressureTendency?
    let past24HourTemperatureDeparture, apparentTemperature, windChillTemperature, wetBulbTemperature: Temperature?
    let wetBulbGlobeTemperature, precip1Hr: Temperature?
    let precipitationSummary: [String: Temperature]?
    let temperatureSummary: TemperatureSummary?
    let mobileLink, link: String?
    
    enum CodingKeys: String, CodingKey {
        case epochTime = "EpochTime"
        case weatherText = "WeatherText"
        case weatherIcon = "WeatherIcon"
        case hasPrecipitation = "HasPrecipitation"
        case precipitationType = "PrecipitationType"
        case isDayTime = "IsDayTime"
        case temperature = "Temperature"
        case realFeelTemperature = "RealFeelTemperature"
        case realFeelTemperatureShade = "RealFeelTemperatureShade"
        case relativeHumidity = "RelativeHumidity"
        case indoorRelativeHumidity = "IndoorRelativeHumidity"
        case dewPoint = "DewPoint"
        case wind = "Wind"
        case windGust = "WindGust"
        case uvIndex = "UVIndex"
        case uvIndexText = "UVIndexText"
        case visibility = "Visibility"
        case obstructionsToVisibility = "ObstructionsToVisibility"
        case cloudCover = "CloudCover"
        case ceiling = "Ceiling"
        case pressure = "Pressure"
        case pressureTendency = "PressureTendency"
        case past24HourTemperatureDeparture = "Past24HourTemperatureDeparture"
        case apparentTemperature = "ApparentTemperature"
        case windChillTemperature = "WindChillTemperature"
        case wetBulbTemperature = "WetBulbTemperature"
        case wetBulbGlobeTemperature = "WetBulbGlobeTemperature"
        case precip1Hr = "Precip1hr"
        case precipitationSummary = "PrecipitationSummary"
        case temperatureSummary = "TemperatureSummary"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
    
    private func getRealFeelTemp() -> Double {
        let storedValue = UserDefaults.standard.string(forKey: "tempUnits") ?? ""
        let selectedUnit = TemperatureUnits(rawValue: storedValue) ?? .celsius
        switch selectedUnit {
        case .celsius:
            return realFeelTemperature?.metric?.value ?? 0
        case .fahrenheit:
            return realFeelTemperature?.imperial?.value ?? 0
        }
    }
    
    func getCurrentTemperature() -> String {
        let storedValue = UserDefaults.standard.string(forKey: "tempUnits") ?? ""
        let selectedUnit = TemperatureUnits(rawValue: storedValue) ?? .celsius
        switch selectedUnit {
        case .celsius:
            return temperature?.metric?.value?.roundeValue() ?? "0°"
        case .fahrenheit:
            return temperature?.imperial?.value?.roundeValue() ?? "0°"
        }
    }
    
    func getMinMaxTemp() -> String {
        let storedValue = UserDefaults.standard.string(forKey: "tempUnits") ?? ""
        let selectedUnit = TemperatureUnits(rawValue: storedValue) ?? .celsius
        let tempSummary = temperatureSummary
        switch selectedUnit {
        case .celsius:
            let maxTemp = "\(tempSummary?.past24HourRange?.maximum?.metric?.value?.roundeValue() ?? "0")°"
            let minTemp = "\(tempSummary?.past24HourRange?.minimum?.metric?.value?.roundeValue() ?? "0")°"
            return "\(maxTemp)/\(minTemp)"
        case .fahrenheit:
            let maxTemp = "\(tempSummary?.past24HourRange?.maximum?.imperial?.value?.roundeValue() ?? "0")°"
            let minTemp = "\(tempSummary?.past24HourRange?.minimum?.imperial?.value?.roundeValue() ?? "0")°"
            return "\(maxTemp)/\(minTemp)"
        }
    }
    
    func getUVIndexProgress() -> Double {
        if (uvIndex ?? 0) == 0 {
            return 0
        }
        let minIndex: Double = 0.0
        let maxIndex: Double = 11.0
        let currentIndex: Double = Double(uvIndex ?? 0)
        let a1 = (currentIndex - minIndex)
        let a2 = (maxIndex - minIndex)
        let a3 = (0.9 - 0.1) + 0.1
        //let val =  (((currentIndex - minIndex) / (maxIndex - minIndex)) * (0.9 - 0.1) + 0.1)
        return (a1 / a2) * a3
    }
    
    func getRealFeelProgress() -> Double {
        guard let minTemp = temperatureSummary?.getMinTemp(),
                  let maxTemp = temperatureSummary?.getMaxTemp() else { return 0.1 }
            
            let currentTemp = getRealFeelTemp()

            // Avoid division by zero
            guard maxTemp > minTemp else { return 0.1 }

            let progress = (currentTemp - minTemp) / (maxTemp - minTemp)

            // Correct scaling: Ensure within 0.1 to 0.9 range
            return max(0.1, min(0.9, 0.1 + (progress * 0.8)))
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    var metric, imperial: Imperial?
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

// MARK: - Imperial
struct Imperial: Codable {
    var value: Double?
    var unit: String?
    var unitType: Int?
    var phrase: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
        case phrase = "Phrase"
    }
}

struct PressureTendency: Codable {
    let localizedText, code: String?
    
    enum CodingKeys: String, CodingKey {
        case localizedText = "LocalizedText"
        case code = "Code"
    }
}

struct TemperatureSummary: Codable {
    let past6HourRange, past12HourRange, past24HourRange: PastHourRange?
    
    enum CodingKeys: String, CodingKey {
        case past6HourRange = "Past6HourRange"
        case past12HourRange = "Past12HourRange"
        case past24HourRange = "Past24HourRange"
    }
    
    func getMinTemp() -> Double {
        let unit = UserDefaults.standard.string(forKey: "tempUnits") ?? ""
        switch TemperatureUnits(rawValue: unit) ?? .celsius {
        case .celsius:
            return past24HourRange?.minimum?.metric?.value ?? 0
        case .fahrenheit:
            return past24HourRange?.minimum?.imperial?.value ?? 0
        }
    }
    
    func getMaxTemp() -> Double {
        let unit = UserDefaults.standard.string(forKey: "tempUnits") ?? ""
        switch TemperatureUnits(rawValue: unit) ?? .celsius {
        case .celsius:
            return past24HourRange?.maximum?.metric?.value ?? 0
        case .fahrenheit:
            return past24HourRange?.maximum?.imperial?.value ?? 0
        }
    }
}

struct PastHourRange: Codable {
    let minimum, maximum: Temperature?
    
    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

struct Wind: Codable {
    let direction: Direction?
    let speed: Temperature?
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
    }
}

struct WindModel: Codable {
    let direction: Direction?
    let speed: Imperial?
    
    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
    }
}

struct Direction: Codable {
    let degrees: Int?
    let localized, english: String?
    
    enum CodingKeys: String, CodingKey {
        case degrees = "Degrees"
        case localized = "Localized"
        case english = "English"
    }
}

struct WindGust: Codable {
    let speed: Temperature?
    
    enum CodingKeys: String, CodingKey {
        case speed = "Speed"
    }
}
