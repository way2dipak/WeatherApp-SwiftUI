//
//  HomeDataModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import Foundation
import RealmSwift
import CoreLocation

class HomeDataModelEntity: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var timestamp: Int = 0
    @Persisted var isDefault: Bool = false
    @Persisted var geoPosition: GeoPositionModelEntity?
    @Persisted var currentWeatherDetails: CurrentWeatherModelEntity?
    @Persisted var forecastDetails: FiveDayForecastModelEntity?
    @Persisted var hourlyForecasts: List<HourlyWeatherForecastModelEntity>

    convenience init(geoPosition: GeoPositionModelEntity? = nil,
                     weatherDetails: CurrentWeatherModelEntity? = nil,
                     forecastDetails: FiveDayForecastModelEntity? = nil,
                     hourlyForecasts: [HourlyWeatherForecastModelEntity]? = nil,
                     isDefault: Bool = false
    ) {
        self.init()
        self.key = geoPosition?.key ?? ""
        self.timestamp = weatherDetails?.epochTime ?? 0
        self.isDefault = isDefault
        self.geoPosition = geoPosition
        self.currentWeatherDetails = weatherDetails
        self.forecastDetails = forecastDetails
        if let hourlyForecasts = hourlyForecasts {
            self.hourlyForecasts.append(objectsIn: hourlyForecasts)
        }
    }
    
    var hourlyForecastsList: [HourlyWeatherForecastModelEntity] {
        return Array(hourlyForecasts)
    }
    
    func isDefaultLocation() -> Bool {
        guard let storedLocation = geoPosition?.geoPosition,
                  let currentLocation = LocationManager.shared.location?.coordinate else {
                return false
            }
            
            let tolerance: Double = 0.001 // Adjust as needed (about 100m accuracy)
            
        let isLatitudeClose = abs((storedLocation.latitude ?? 0) - currentLocation.latitude) <= tolerance
        let isLongitudeClose = abs((storedLocation.longitude ?? 0) - currentLocation.longitude) <= tolerance
            
            return isLatitudeClose && isLongitudeClose
    }
}
