//
//  WeatherDataRepository.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/10/23.
//

import Foundation
import Combine

protocol WeatherRepository {
    func getCurrentGeoPosition(for params: [String: Any]) -> AnyPublisher<GeoPositionModel?, NetworkError>
    func getCurrentWeatherDetails(for id: String) -> AnyPublisher<CurrentWeatherModel?, NetworkError>
    func getFiveDayForecastDetails(for id: String) ->  AnyPublisher<FiveDayWeatherModel?, NetworkError>
    func getHourlyForecastDetails(for id: String) ->  AnyPublisher<[HourlyWeatherModel]?, NetworkError>
    
    func getWeatherDetails(key: String,
                           timeStamp: Int,
                           isForceUpdate: Bool,
                           params: [String: Any]) -> AnyPublisher<[HomeDataModelEntity], NetworkError>
    
    func fetchCityList() -> AnyPublisher<[HomeDataModelEntity], NetworkError>
}

class WeatherDataRepository: WeatherRepository {
    private let network = NetworkManager.shared
    private let key = LocationManager.shared.currentPosition?.key ?? ""
    init() {
        
    }
    
    func getWeatherDetails(key: String,
                           timeStamp: Int,
                           isForceUpdate: Bool = false,
                           params: [String: Any]) -> AnyPublisher<[HomeDataModelEntity], NetworkError> {
        if !key.isEmpty {
            return self.fetchWeatherDetails(using: key, geoPosition: nil)
        }
        
        return getCurrentGeoPosition(for: params)
            .flatMap { [weak self] geoPosition -> AnyPublisher<[HomeDataModelEntity], NetworkError> in
                guard let self = self else {
                    return Fail(error: NetworkError.custom("Self deallocated")).eraseToAnyPublisher()
                }
                
                let key = geoPosition?.key ?? ""
                return self.fetchWeatherDetails(using: key, geoPosition: geoPosition)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func fetchWeatherDetails(using key: String,
                                     geoPosition: GeoPositionModel? = nil) -> AnyPublisher<[HomeDataModelEntity], NetworkError> {
        
        let currentWeatherPublisher = self.getCurrentWeatherDetails(for: key)
        let fiveDayForecastPublisher = self.getFiveDayForecastDetails(for: key)
        let hourlyForecastPublisher = self.getHourlyForecastDetails(for: key)
        
        return Publishers.Zip3(currentWeatherPublisher, fiveDayForecastPublisher, hourlyForecastPublisher)
            .flatMap { currentWeather, fiveDayForecast, hourlyForecasts -> AnyPublisher<HomeDataModelEntity, NetworkError> in
                if let geoPosition = geoPosition {
                    let geoPositionEntity = GeoPositionModelEntity(model: geoPosition)
                    return Just(
                        HomeDataModelEntity(
                            geoPosition: geoPositionEntity,
                            weatherDetails: CurrentWeatherModelEntity(model: currentWeather),
                            forecastDetails: FiveDayForecastModelEntity(model: fiveDayForecast),
                            hourlyForecasts: (hourlyForecasts ?? []).map { HourlyWeatherForecastModelEntity(model: $0) },
                            isDefault: true
                        )
                    )
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
                } else {
                    // Fetch cached GeoPositionModelEntity from Realm
                    let predicate = NSPredicate(format: "key == %@", key)
                    return PersistanceManager.get(fromEntity: HomeDataModelEntity.self, predicate: predicate)
                        .map { homeEntities in
                            let geoPositionEntity = homeEntities.first?.geoPosition
                            return HomeDataModelEntity(geoPosition: geoPositionEntity,
                                                       weatherDetails: CurrentWeatherModelEntity(model: currentWeather),
                                                       forecastDetails: FiveDayForecastModelEntity(model: fiveDayForecast),
                                                       hourlyForecasts: (hourlyForecasts ?? []).map { HourlyWeatherForecastModelEntity(model: $0) },
                                                       isDefault: homeEntities.first?.isDefault ?? false)
                        }
                        .eraseToAnyPublisher()
                }
            }
            .flatMap { homeEntity in
                PersistanceManager.add(homeEntity)
                    .map { _ in homeEntity }
                    .mapError { NetworkError.custom($0.localizedDescription) }
            }
            .flatMap { _ in
                return self.fetchCityList()
            }
            .eraseToAnyPublisher()
    }
}

extension WeatherDataRepository {
    func getCurrentGeoPosition(for params: [String : Any]) -> AnyPublisher<GeoPositionModel?, NetworkError> {
        var request = URLRepository.geoPosition.dataRequest
        request.queryParams = params
        return network.performRequest(request: request)
            .tryMap { (response: GeoPositionModel) -> GeoPositionModel in
                return response
            }
            .mapError { error in
                print("mapError: \(error.localizedDescription)")
                return NetworkError.custom(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getCurrentWeatherDetails(for id: String) -> AnyPublisher<CurrentWeatherModel?, NetworkError> {
        var request = URLRepository.currentWeather(id).dataRequest
        request.queryParams = ["details": true]
        return network.performRequest(request: request)
            .tryMap { (response: [CurrentWeatherModel]) -> CurrentWeatherModel? in
                return response.first
            }
            .mapError { error in
                print("mapError: \(error.localizedDescription)")
                return NetworkError.custom(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func getFiveDayForecastDetails(for id: String) -> AnyPublisher<FiveDayWeatherModel?, NetworkError> {
        var request = URLRepository.fiveDayForecast(id).dataRequest
        request.queryParams = ["metric" : true]
        return network.performRequest(request: request)
            .tryMap { (response: FiveDayWeatherModel) -> FiveDayWeatherModel in
                return response
            }
            .mapError { error in
                print("mapError: \(error.localizedDescription)")
                return NetworkError.custom(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getHourlyForecastDetails(for id: String) -> AnyPublisher<[HourlyWeatherModel]?, NetworkError> {
        var request = URLRepository.hourlyForcast(id).dataRequest
        request.queryParams = ["metric" : true]
        return network.performRequest(request: request)
            .tryMap { (response: [HourlyWeatherModel]) -> [HourlyWeatherModel]? in
                return response
            }
            .mapError { error in
                print("mapError: \(error.localizedDescription)")
                return NetworkError.custom(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchCityList() -> AnyPublisher<[HomeDataModelEntity], NetworkError> {
        return PersistanceManager.get(fromEntity: HomeDataModelEntity.self)
    }
}

