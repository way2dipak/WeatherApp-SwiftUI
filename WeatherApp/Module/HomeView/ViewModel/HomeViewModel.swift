//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import Foundation
import SwiftData
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var currentWeatherDetails: CurrentWeatherModelEntity?
    var fiveDaysWeatherDetails: FiveDayForecastModelEntity?//FiveDayWeatherModel?
    var hourlyWeatherDetails: [HourlyWeatherForecastModelEntity]?
    @Published var errorMsg: String?
    @Published var homeData: [HomeDataModelEntity] = []
    @Published var cityList: [GeoPositionModelEntity] = []
    
    var currentPostion: GeoPositionModelEntity?
    private var dataManager: WeatherDataManager?
    
    private var key: String = ""
    private var timeStamp: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(dataManager: WeatherDataManager = WeatherDataManager()) {
        self.dataManager = dataManager
    }
    
    func fetchWeatherDetails(isForceUpdate: Bool = false) {
        guard let location = LocationManager.shared.location else {
            errorMsg = "Location not available"
            return
        }
        
        var position: [String: Any] = [:]
        if let currentPostion = currentPostion {
            position = ["q": "\(currentPostion.geoPosition?.latitude ?? 0),\(currentPostion.geoPosition?.longitude ?? 0)"]
        } else {
            position = ["q": "\(location.coordinate.latitude),\(location.coordinate.longitude)"]
        }
         
        
        dataManager?.getWeatherDetails(key: key,
                                       timeStamp: timeStamp,
                                       isForceUpdate: isForceUpdate,
                                       params: position)
            .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.errorMsg = error.localizedDescription
                }
            }, receiveValue: { [weak self] homeData in
                guard let self = self else { return }
                if let key = self.currentPostion?.key {
                    self.homeData = homeData
                    isDayTime = homeData.filter({ $0.key == key }).first?.currentWeatherDetails?.isDayTime ?? false
                    self.currentWeatherDetails = homeData.filter({ $0.key == key }).first?.currentWeatherDetails
                    self.fiveDaysWeatherDetails = homeData.filter({ $0.key == key }).first?.forecastDetails
                    self.hourlyWeatherDetails = homeData.filter({ $0.key == key }).first?.hourlyForecastsList
                    if let index = homeData.firstIndex(where: { $0.key == key }) {
                        self.updateCurrentDetails(for: index)
                    }
                } else {
                    self.homeData = homeData
                    isDayTime = homeData.first?.currentWeatherDetails?.isDayTime ?? false
                    self.currentWeatherDetails = homeData.first?.currentWeatherDetails
                    self.fiveDaysWeatherDetails = homeData.first?.forecastDetails
                    self.hourlyWeatherDetails = homeData.first?.hourlyForecastsList
                    self.updateCurrentDetails(for: 0)
                }
            })
            .store(in: &cancellables)
    }
    
    func updateCurrentDetails(for position: Int) {
        if !homeData.isEmpty {
            isDayTime = homeData[position].currentWeatherDetails?.isDayTime ?? false
            self.currentWeatherDetails = homeData[position].currentWeatherDetails
            self.fiveDaysWeatherDetails = homeData[position].forecastDetails
            self.hourlyWeatherDetails = homeData[position].hourlyForecastsList
            self.currentPostion = homeData[position].geoPosition
            self.timeStamp = homeData[position].timestamp
            self.key = homeData[position].key
        }
    }
    
    func getCurrentWatherIcon(for index: Int) -> Int {
        if homeData.count == 0 {
            return 0
        }
        return homeData[index].currentWeatherDetails?.weatherIcon ?? 0
    }
    
}

//ManageCityView
extension HomeViewModel {
    func fetchCityList() {
        dataManager?.fetchCityList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] homeData in
                self?.homeData = homeData
            })
            .store(in: &cancellables)
    }
}
