//
//  LaunchViewModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 22/10/23.
//

import Combine
import CoreLocation

class LaunchViewModel: ObservableObject {
    @Published var geoPosition: GeoPositionModel?
    @Published var errorMsg: String?
    @Published var locationReceived: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        requestForLocationAccess()
        observeLocationPublisher()
    }

    private func requestForLocationAccess() {
        LocationManager.shared.requestLocation()
    }

    private func observeLocationPublisher() {
        LocationManager.shared.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                }
            } receiveValue: { location in
                self.locationReceived = true
            }
            .store(in: &cancellables)
    }

//    private func getGeoPosition(for location: CLLocation) {
//        let dataManager = WeatherDataManager()
//        let position = ["q": "\(location.coordinate.latitude),\(location.coordinate.longitude)"]
//        dataManager.getCurrentGeoPosition(for: position)
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let error):
//                    self.errorMsg = error.localizedDescription
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] position in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    self.geoPosition = position
//                    LocationManager.shared.currentPosition = position
//                }
//            }
//            .store(in: &cancellables)
//
//    }
}


