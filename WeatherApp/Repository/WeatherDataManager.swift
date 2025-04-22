//
//  WeatherDataManager.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/10/23.
//

import Foundation
import Combine

class WeatherDataManager: WeatherRepository {
    private let repo = WeatherDataRepository()
    
    func getWeatherDetails(key: String,
                           timeStamp: Int,
                           isForceUpdate: Bool,
                           params: [String : Any]) -> AnyPublisher<[HomeDataModelEntity], NetworkError> {
        return repo.fetchCityList()
            .flatMap { existingData -> AnyPublisher<[HomeDataModelEntity], NetworkError> in
                let defaultTimeStamp = existingData.first?.timestamp ?? 0
                let defaultLocationKey = existingData.first?.key ?? ""
                
                // If DB is empty, call API (First-time scenario)
                if existingData.isEmpty {
                    return self.repo.getWeatherDetails(key: key,
                                                       timeStamp: timeStamp,
                                                       isForceUpdate: isForceUpdate,
                                                       params: params)
                }
                
                // If force update is requested, call API
                if isForceUpdate {
                    return self.repo.getWeatherDetails(key: key,
                                                       timeStamp: timeStamp,
                                                       isForceUpdate: isForceUpdate,
                                                       params: params)
                }
                
                // If time difference exceeds threshold, call API
                if Utils.isApiCallRequired(lastTimeStamp: defaultTimeStamp) {
                    return self.repo.getWeatherDetails(key: key == "" ? defaultLocationKey : key,
                                                       timeStamp: defaultTimeStamp,
                                                       isForceUpdate: isForceUpdate,
                                                       params: params)
                }
                
                // Otherwise, return cached data
                return Just(existingData)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension WeatherDataManager {
    func getCurrentGeoPosition(for params: [String : Any]) -> AnyPublisher<GeoPositionModel?, NetworkError> {
        return repo.getCurrentGeoPosition(for: params)
    }
    
    func getCurrentWeatherDetails(for id: String) -> AnyPublisher<CurrentWeatherModel?, NetworkError> {
        return repo.getCurrentWeatherDetails(for: id)
    }
    
    func getFiveDayForecastDetails(for id: String) -> AnyPublisher<FiveDayWeatherModel?, NetworkError> {
        return repo.getFiveDayForecastDetails(for: id)
    }
    
    func getHourlyForecastDetails(for id: String) -> AnyPublisher<[HourlyWeatherModel]?, NetworkError> {
        return repo.getHourlyForecastDetails(for: id)
    }
    
    func fetchCityList() -> AnyPublisher<[HomeDataModelEntity], NetworkError> {
        return repo.fetchCityList()
    }
}
