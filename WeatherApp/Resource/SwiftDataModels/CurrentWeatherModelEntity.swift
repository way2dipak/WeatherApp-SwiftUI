//
//  CurrentWeatherModelEntity.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/03/25.
//

import Foundation
import RealmSwift


class CurrentWeatherModelEntity: EmbeddedObject {
    @Persisted var epochTime: Int?
    @Persisted var weatherText: String?
    @Persisted var weatherIcon: Int?
    @Persisted var hasPrecipitation: Bool = false
    @Persisted var precipitationType: String?
    @Persisted var isDayTime: Bool = false
    @Persisted var relativeHumidity: Int?
    @Persisted var indoorRelativeHumidity: Int?
    @Persisted var uvIndex: Int?
    @Persisted var uvIndexText: String?
    @Persisted var obstructionsToVisibility: String?
    @Persisted var cloudCover: Int?
    @Persisted var mobileLink: String?
    @Persisted var link: String?
    
    @Persisted var temperature: TemperatureEntity?
    @Persisted var realFeelTemperature: TemperatureEntity?
    @Persisted var realFeelTemperatureShade: TemperatureEntity?
    @Persisted var dewPoint: TemperatureEntity?
    @Persisted var wind: WindEntity?
    @Persisted var windGust: WindGustEntity?
    @Persisted var visibility: TemperatureEntity?
    @Persisted var ceiling: TemperatureEntity?
    @Persisted var pressure: TemperatureEntity?
    @Persisted var pressureTendency: PressureTendencyEntity?
    @Persisted var past24HourTemperatureDeparture: TemperatureEntity?
    @Persisted var apparentTemperature: TemperatureEntity?
    @Persisted var windChillTemperature: TemperatureEntity?
    @Persisted var wetBulbTemperature: TemperatureEntity?
    @Persisted var wetBulbGlobeTemperature: TemperatureEntity?
    @Persisted var precip1Hr: TemperatureEntity?
    @Persisted var temperatureSummary: TemperatureSummaryEntity?
    
    convenience init(model: CurrentWeatherModel?) {
        self.init()
        self.epochTime = model?.epochTime
        self.weatherText = model?.weatherText
        self.weatherIcon = model?.weatherIcon
        self.hasPrecipitation = model?.hasPrecipitation ?? false
        self.precipitationType = model?.precipitationType
        self.isDayTime = model?.isDayTime ?? false
        self.relativeHumidity = model?.relativeHumidity
        self.indoorRelativeHumidity = model?.indoorRelativeHumidity
        self.uvIndex = model?.uvIndex
        self.uvIndexText = model?.uvIndexText
        self.obstructionsToVisibility = model?.obstructionsToVisibility
        self.cloudCover = model?.cloudCover
        self.mobileLink = model?.mobileLink
        self.link = model?.link
        
        self.temperature = model?.temperature.map { TemperatureEntity(model: $0) }
        self.realFeelTemperature = model?.realFeelTemperature.map { TemperatureEntity(model: $0) }
        self.realFeelTemperatureShade = model?.realFeelTemperatureShade.map { TemperatureEntity(model: $0) }
        self.dewPoint = model?.dewPoint.map { TemperatureEntity(model: $0) }
        self.wind = model?.wind.map { WindEntity(model: $0) }
        self.windGust = model?.windGust.map { WindGustEntity(model: $0) }
        self.visibility = model?.visibility.map { TemperatureEntity(model: $0) }
        self.ceiling = model?.ceiling.map { TemperatureEntity(model: $0) }
        self.pressure = model?.pressure.map { TemperatureEntity(model: $0) }
        self.pressureTendency = model?.pressureTendency.map { PressureTendencyEntity(model: $0) }
        self.past24HourTemperatureDeparture = model?.past24HourTemperatureDeparture.map { TemperatureEntity(model: $0) }
        self.apparentTemperature = model?.apparentTemperature.map { TemperatureEntity(model: $0) }
        self.windChillTemperature = model?.windChillTemperature.map { TemperatureEntity(model: $0) }
        self.wetBulbTemperature = model?.wetBulbTemperature.map { TemperatureEntity(model: $0) }
        self.wetBulbGlobeTemperature = model?.wetBulbGlobeTemperature.map { TemperatureEntity(model: $0) }
        self.precip1Hr = model?.precip1Hr.map { TemperatureEntity(model: $0) }
        self.temperatureSummary = model?.temperatureSummary.map { TemperatureSummaryEntity(model: $0) }
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

class TemperatureEntity: EmbeddedObject {
    @Persisted var metric: ImperialEntity?
    @Persisted var imperial: ImperialEntity?
    
    convenience init(model: Temperature?) {
        self.init()
        self.metric = model?.metric.map { ImperialEntity(model: $0) }
        self.imperial = model?.imperial.map { ImperialEntity(model: $0) }
    }
}

class ImperialEntity: EmbeddedObject {
    @Persisted var value: Double?
    @Persisted var unit: String?
    @Persisted var unitType: Int?
    @Persisted var phrase: String?
    
    convenience init(model: Imperial?) {
        self.init()
        self.value = model?.value
        self.unit = model?.unit
        self.unitType = model?.unitType
        self.phrase = model?.phrase
    }
}

class WindEntity: EmbeddedObject {
    @Persisted var direction: DirectionEntity?
    @Persisted var speed: TemperatureEntity?
    
    convenience init(model: Wind?) {
        self.init()
        self.direction = model?.direction.map { DirectionEntity(model: $0) }
        self.speed = model?.speed.map { TemperatureEntity(model: $0) }
    }
}

class DirectionEntity: EmbeddedObject {
    @Persisted var degrees: Int?
    @Persisted var localized: String?
    @Persisted var english: String?
    
    convenience init(model: Direction?) {
        self.init()
        self.degrees = model?.degrees
        self.localized = model?.localized
        self.english = model?.english
    }
}

class WindGustEntity: EmbeddedObject {
    @Persisted var speed: TemperatureEntity?
    
    convenience init(model: WindGust?) {
        self.init()
        self.speed = model?.speed.map { TemperatureEntity(model: $0) }
    }
}

class PressureTendencyEntity: EmbeddedObject {
    @Persisted var localizedText: String?
    @Persisted var code: String?
    
    convenience init(model: PressureTendency?) {
        self.init()
        self.localizedText = model?.localizedText
        self.code = model?.code
    }
}

class TemperatureSummaryEntity: EmbeddedObject {
    @Persisted var past6HourRange: PastHourRangeEntity?
    @Persisted var past12HourRange: PastHourRangeEntity?
    @Persisted var past24HourRange: PastHourRangeEntity?
    
    convenience init(model: TemperatureSummary?) {
        self.init()
        self.past6HourRange = model?.past6HourRange.map { PastHourRangeEntity(model: $0) }
        self.past12HourRange = model?.past12HourRange.map { PastHourRangeEntity(model: $0) }
        self.past24HourRange = model?.past24HourRange.map { PastHourRangeEntity(model: $0) }
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

class PastHourRangeEntity: EmbeddedObject {
    @Persisted var minimum: TemperatureEntity?
    @Persisted var maximum: TemperatureEntity?
    
    convenience init(model: PastHourRange?) {
        self.init()
        self.minimum = model?.minimum.map { TemperatureEntity(model: $0) }
        self.maximum = model?.maximum.map { TemperatureEntity(model: $0) }
    }
}
