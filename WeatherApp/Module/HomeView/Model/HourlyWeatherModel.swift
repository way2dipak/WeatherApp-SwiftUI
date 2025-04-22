//
//  HourlyWeatherModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 04/02/25.
//

import Foundation

struct HourlyWeatherModel: Identifiable, Codable {
    let id = UUID().uuidString
    let dateTime: String?
    let epochDateTime, weatherIcon: Int?
    let iconPhrase: String?
    let hasPrecipitation, isDaylight: Bool?
    let temperature, realFeelTemperature, realFeelTemperatureShade, wetBulbTemperature: Imperial?
    let wetBulbGlobeTemperature, dewPoint: Imperial?
    let wind: WindModel?
    let windGust: WindGust?
    let relativeHumidity, indoorRelativeHumidity: Int?
    let visibility, ceiling: Imperial?
    let uvIndex: Int?
    let uvIndexText: String?
    let precipitationProbability, thunderstormProbability, rainProbability, snowProbability: Int?
    let iceProbability: Int?
    let totalLiquid, rain, snow, ice: Imperial?
    let cloudCover: Int?
    let evapotranspiration, solarIrradiance: Imperial?
    let mobileLink, link: String?
    var iconLink: String {
        get {
            return "https://openweathermap.org/img/wn/\(openWeatherMappedIcon["\(weatherIcon ?? 0)"] ?? "01d")@2x.png"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case epochDateTime = "EpochDateTime"
        case weatherIcon = "WeatherIcon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case isDaylight = "IsDaylight"
        case temperature = "Temperature"
        case realFeelTemperature = "RealFeelTemperature"
        case realFeelTemperatureShade = "RealFeelTemperatureShade"
        case wetBulbTemperature = "WetBulbTemperature"
        case wetBulbGlobeTemperature = "WetBulbGlobeTemperature"
        case dewPoint = "DewPoint"
        case wind = "Wind"
        case windGust = "WindGust"
        case relativeHumidity = "RelativeHumidity"
        case indoorRelativeHumidity = "IndoorRelativeHumidity"
        case visibility = "Visibility"
        case ceiling = "Ceiling"
        case uvIndex = "UVIndex"
        case uvIndexText = "UVIndexText"
        case precipitationProbability = "PrecipitationProbability"
        case thunderstormProbability = "ThunderstormProbability"
        case rainProbability = "RainProbability"
        case snowProbability = "SnowProbability"
        case iceProbability = "IceProbability"
        case totalLiquid = "TotalLiquid"
        case rain = "Rain"
        case snow = "Snow"
        case ice = "Ice"
        case cloudCover = "CloudCover"
        case evapotranspiration = "Evapotranspiration"
        case solarIrradiance = "SolarIrradiance"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
    
    static func == (lhs: HourlyWeatherModel, rhs: HourlyWeatherModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}
