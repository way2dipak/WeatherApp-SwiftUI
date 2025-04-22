//
//  FiveDayForecastModelEntity.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/03/25.
//

import Foundation
import RealmSwift


class FiveDayForecastModelEntity: EmbeddedObject {
    @Persisted var headline: HeadlineEntity?
    @Persisted var dailyForecasts: List<DailyForecastEntity>
    
    convenience init(model: FiveDayWeatherModel?) {
        self.init()
        self.headline = model?.headline.map { HeadlineEntity(model: $0) }
        self.dailyForecasts.append(objectsIn: model?.dailyForecasts?.map { DailyForecastEntity(model: $0) } ?? [])
    }
    
    func getForecastLimit(value: Int) -> [DailyForecastEntity]? {
        return Array(dailyForecasts.prefix(value))
    }
}

class HeadlineEntity: EmbeddedObject {
    @Persisted var effectiveDate: String?
    @Persisted var effectiveEpochDate: Int?
    @Persisted var severity: Int?
    @Persisted var text: String?
    @Persisted var category: String?
    @Persisted var endDate: String?
    @Persisted var endEpochDate: Int?
    @Persisted var mobileLink: String?
    @Persisted var link: String?
    
    convenience init(model: Headline?) {
        self.init()
        self.effectiveDate = model?.effectiveDate
        self.effectiveEpochDate = model?.effectiveEpochDate
        self.severity = model?.severity
        self.text = model?.text
        self.category = model?.category
        self.endDate = model?.endDate
        self.endEpochDate = model?.endEpochDate
        self.mobileLink = model?.mobileLink
        self.link = model?.link
    }
}

class DailyForecastEntity: EmbeddedObject, Identifiable {
    @Persisted var date: String?
    @Persisted var epochDate: Int?
    @Persisted var temperature: DailyForecastTemperatureEntity?
    @Persisted var day: WeatherConditionEntity?
    @Persisted var night: WeatherConditionEntity?
    @Persisted var sources: List<String>
    @Persisted var mobileLink: String?
    @Persisted var link: String?
    
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
    
    convenience init(model: DailyForecast?) {
        self.init()
        self.date = model?.date
        self.epochDate = model?.epochDate
        self.temperature = model?.temperature.map { DailyForecastTemperatureEntity(model: $0) }
        self.day = model?.day.map { WeatherConditionEntity(model: $0) }
        self.night = model?.night.map { WeatherConditionEntity(model: $0) }
        self.sources.append(objectsIn: model?.sources ?? [])
        self.mobileLink = model?.mobileLink
        self.link = model?.link
    }
    
    func getMinTemp() -> Double {
        return temperature?.minimum?.value ?? 0
    }
    
    func getMaxTemp() -> Double {
        return temperature?.maximum?.value ?? 0
    }
}

class DailyForecastTemperatureEntity: EmbeddedObject {
    @Persisted var minimum: TemperatureDetailEntity?
    @Persisted var maximum: TemperatureDetailEntity?
    
    convenience init(model: DailyForecastTemperature?) {
        self.init()
        self.minimum = model?.minimum.map { TemperatureDetailEntity(model: $0) }
        self.maximum = model?.maximum.map { TemperatureDetailEntity(model: $0) }
    }
}

class TemperatureDetailEntity: EmbeddedObject {
    @Persisted var value: Double?
    @Persisted var unit: String?
    @Persisted var unitType: Int?
    
    convenience init(model: Imum?) {
        self.init()
        self.value = model?.value
        self.unit = model?.unit
        self.unitType = model?.unitType
    }
}

class WeatherConditionEntity: EmbeddedObject {
    @Persisted var icon: Int?
    @Persisted var iconPhrase: String?
    @Persisted var hasPrecipitation: Bool = false
    
    convenience init(model: Day?) {
        self.init()
        self.icon = model?.icon
        self.iconPhrase = model?.iconPhrase
        self.hasPrecipitation = model?.hasPrecipitation ?? false
    }
}
