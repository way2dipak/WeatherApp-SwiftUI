//
//  ApiMock.swift
//  WeatherApp
//
//  Created by Dipak Singh on 03/02/25.
//

import Foundation

struct ApiMock {
    
    static func getCurrentGeoPosition() -> GeoPositionModel? {
        guard let url = Bundle.main.url(forResource: "GeoLocationMock", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let geoPosition = try JSONDecoder().decode(GeoPositionModel.self, from: data)
            return geoPosition
        } catch let error {
            print("Error decoding mock JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getCurrentWeatherJson() -> CurrentWeatherModel? {
        guard let url = Bundle.main.url(forResource: "CurrentWeatherMock", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let currentWeather = try JSONDecoder().decode([CurrentWeatherModel].self, from: data)
            return currentWeather.first
        } catch let error {
            print("Error decoding mock JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getForecastJson() -> FiveDayWeatherModel? {
        guard let url = Bundle.main.url(forResource: "FiveDayForecastMock", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let fiveDayForecast = try JSONDecoder().decode(FiveDayWeatherModel.self, from: data)
            return fiveDayForecast
        } catch let error {
            print("Error decoding mock JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func get12HourWeatherJson() -> [HourlyWeatherModel]? {
        guard let url = Bundle.main.url(forResource: "12HourMock", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let hourlyJson = try JSONDecoder().decode([HourlyWeatherModel].self, from: data)
            return hourlyJson
        } catch let error {
            print("Error decoding mock JSON: \(error)")
            return nil
        }
    }
}
