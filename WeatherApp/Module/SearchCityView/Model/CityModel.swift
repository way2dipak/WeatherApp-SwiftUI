//
//  CityModel.swift
//  WeatherApp
//
//  Created by Dipak Singh on 08/02/25.
//

import SwiftUI
import SwiftData

@Model
class CityModel {
    @Attribute(.unique) var key: String // Unique Identifier
    var localizedName: String
    var englishName: String
    var country: Country?
    var administrativeArea: AdministrativeArea?
    var timeZone: TimeZone?
    var geoPosition: GeoPosition?
    var supplementalAdminAreas: [SupplementalAdminArea] = []
    var currentWeather: CurrentWeatherModel?
    init(model: GeoPositionModel) {
        self.key = model.key ?? UUID().uuidString
        self.localizedName = model.localizedName ?? ""
        self.englishName = model.englishName ?? ""
        self.country = model.country ?? nil
        self.administrativeArea = model.administrativeArea ?? nil
        self.timeZone = model.timeZone ?? nil
        self.geoPosition = model.geoPosition ?? nil
        self.supplementalAdminAreas = model.supplementalAdminAreas ?? []
    }
}
