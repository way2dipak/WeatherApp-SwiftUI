//
//  URLRepository.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/10/23.
//

import Foundation

enum URLRepository {
    case geoPosition
    case currentWeather(String)
    case fiveDayForecast(String)
    case hourlyForcast(String)
    case searchByCity
    //
    var dataRequest: APIRequest {
        switch self {
        case .geoPosition:
            return APIRequest(path: "locations/v1/cities/geoposition/search", method: .GET)
        case .currentWeather(let id):
            return APIRequest(path: "currentconditions/v1/\(id)", method: .GET)
        case .hourlyForcast(let id):
            return APIRequest(path: "forecasts/v1/hourly/12hour/\(id)", method: .GET)
        case .fiveDayForecast(let id):
            return APIRequest(path: "forecasts/v1/daily/5day/\(id)", method: .GET)
        case .searchByCity:
            return APIRequest(path: "locations/v1/cities/geoposition/search", method: .GET)
        }
    }

}
