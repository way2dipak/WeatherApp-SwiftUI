//
//  HourlyWeatherForecastModelEntity.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/03/25.
//

import Foundation
import RealmSwift

class HourlyWeatherForecastModelEntity: EmbeddedObject {
    @Persisted var dateTime: String?
    @Persisted var epochDateTime: Int?
    @Persisted var weatherIcon: Int?
    @Persisted var iconPhrase: String?
    @Persisted var hasPrecipitation: Bool?
    @Persisted var isDaylight: Bool?
    
    @Persisted var temperature: ImperialEntity?
    @Persisted var realFeelTemperature: ImperialEntity?
    @Persisted var realFeelTemperatureShade: ImperialEntity?
    @Persisted var wetBulbTemperature: ImperialEntity?
    @Persisted var wetBulbGlobeTemperature: ImperialEntity?
    @Persisted var dewPoint: ImperialEntity?
    
    @Persisted var wind: WindModelEntity?
    @Persisted var windGust: WindGustEntity?
    
    @Persisted var relativeHumidity: Int?
    @Persisted var indoorRelativeHumidity: Int?
    
    @Persisted var visibility: ImperialEntity?
    @Persisted var ceiling: ImperialEntity?
    
    @Persisted var uvIndex: Int?
    @Persisted var uvIndexText: String?
    
    @Persisted var precipitationProbability: Int?
    @Persisted var thunderstormProbability: Int?
    @Persisted var rainProbability: Int?
    @Persisted var snowProbability: Int?
    @Persisted var iceProbability: Int?
    
    @Persisted var totalLiquid: ImperialEntity?
    @Persisted var rain: ImperialEntity?
    @Persisted var snow: ImperialEntity?
    @Persisted var ice: ImperialEntity?
    
    @Persisted var cloudCover: Int?
    
    @Persisted var evapotranspiration: ImperialEntity?
    @Persisted var solarIrradiance: ImperialEntity?
    
    @Persisted var mobileLink: String?
    @Persisted var link: String?

    var iconLink: String {
        return "https://openweathermap.org/img/wn/\(openWeatherMappedIcon["\(weatherIcon ?? 0)"] ?? "01d")@2x.png"
    }
    
    convenience init(model: HourlyWeatherModel?) {
        self.init()
        self.dateTime = model?.dateTime
        self.epochDateTime = model?.epochDateTime
        self.weatherIcon = model?.weatherIcon
        self.iconPhrase = model?.iconPhrase
        self.hasPrecipitation = model?.hasPrecipitation
        self.isDaylight = model?.isDaylight
        self.temperature = model?.temperature.map { ImperialEntity(model: $0) }
        self.realFeelTemperature = model?.realFeelTemperature.map { ImperialEntity(model: $0) }
        self.realFeelTemperatureShade = model?.realFeelTemperatureShade.map { ImperialEntity(model: $0) }
        self.wetBulbTemperature = model?.wetBulbTemperature.map { ImperialEntity(model: $0) }
        self.wetBulbGlobeTemperature = model?.wetBulbGlobeTemperature.map { ImperialEntity(model: $0) }
        self.dewPoint = model?.dewPoint.map { ImperialEntity(model: $0) }
        self.wind = model?.wind.map { WindModelEntity(model: $0) }
        self.windGust = model?.windGust.map { WindGustEntity(model: $0) }
        self.relativeHumidity = model?.relativeHumidity
        self.indoorRelativeHumidity = model?.indoorRelativeHumidity
        self.visibility = model?.visibility.map { ImperialEntity(model: $0) }
        self.ceiling = model?.ceiling.map { ImperialEntity(model: $0) }
        self.uvIndex = model?.uvIndex
        self.uvIndexText = model?.uvIndexText
        self.precipitationProbability = model?.precipitationProbability
        self.thunderstormProbability = model?.thunderstormProbability
        self.rainProbability = model?.rainProbability
        self.snowProbability = model?.snowProbability
        self.iceProbability = model?.iceProbability
        self.totalLiquid = model?.totalLiquid.map { ImperialEntity(model: $0) }
        self.rain = model?.rain.map { ImperialEntity(model: $0) }
        self.snow = model?.snow.map { ImperialEntity(model: $0) }
        self.ice = model?.ice.map { ImperialEntity(model: $0) }
        self.cloudCover = model?.cloudCover
        self.evapotranspiration = model?.evapotranspiration.map { ImperialEntity(model: $0) }
        self.solarIrradiance = model?.solarIrradiance.map { ImperialEntity(model: $0) }
        self.mobileLink = model?.mobileLink
        self.link = model?.link
    }
}

class WindModelEntity: EmbeddedObject {
    @Persisted var direction: DirectionEntity?
    @Persisted var speed: ImperialEntity?

    convenience init(model: WindModel?) {
        self.init()
        self.direction = model?.direction.map { DirectionEntity(model: $0) }
        self.speed = model?.speed.map { ImperialEntity(model: $0) }
    }
}
