//
//  GeoPositionEntity.swift
//  WeatherApp
//
//  Created by Dipak Singh on 09/03/25.
//

import Foundation
import RealmSwift

// MARK: - GeoPositionModelEntity
class GeoPositionModelEntity: EmbeddedObject {
    @Persisted var version: Int?
    @Persisted var key: String?
    @Persisted var type: String?
    @Persisted var rank: Int?
    @Persisted var localizedName: String?
    @Persisted var englishName: String?
    @Persisted var primaryPostalCode: String?
    
    @Persisted var region: CountryEntity?
    @Persisted var country: CountryEntity?
    @Persisted var administrativeArea: AdministrativeAreaEntity?
    @Persisted var timeZone: TimeZoneEntity?
    @Persisted var geoPosition: GeoPositionEntity?
    @Persisted var parentCity: ParentCityEntity?
    @Persisted var supplementalAdminAreas = List<SupplementalAdminAreaEntity>()
    
    @Persisted var dataSets: List<String>
    
    convenience init(model: GeoPositionModel?) {
        self.init()
        self.version = model?.version
        self.key = model?.key
        self.type = model?.type
        self.rank = model?.rank
        self.localizedName = model?.localizedName
        self.englishName = model?.englishName
        self.primaryPostalCode = model?.primaryPostalCode
        self.region = model?.region.map { CountryEntity(model: $0) }
        self.country = model?.country.map { CountryEntity(model: $0) }
        self.administrativeArea = model?.administrativeArea.map { AdministrativeAreaEntity(model: $0) }
        self.timeZone = model?.timeZone.map { TimeZoneEntity(model: $0) }
        self.geoPosition = model?.geoPosition.map { GeoPositionEntity(model: $0) }
        self.parentCity = model?.parentCity.map { ParentCityEntity(model: $0) }
        self.supplementalAdminAreas.append(objectsIn: model?.supplementalAdminAreas?.map { SupplementalAdminAreaEntity(model: $0) } ?? [])
        self.dataSets.append(objectsIn: model?.dataSets ?? [])
    }
    
    func getCityName() -> String {
        guard let parentCity = parentCity else {
            return localizedName ?? ""
        }
        return parentCity.localizedName ?? ""
    }
}

// MARK: - AdministrativeArea
class AdministrativeAreaEntity: EmbeddedObject {
    @Persisted var id: String?
    @Persisted var localizedName: String?
    @Persisted var englishName: String?
    @Persisted var level: Int?
    @Persisted var localizedType: String?
    @Persisted var englishType: String?
    @Persisted var countryID: String?
    
    convenience init(model: AdministrativeArea?) {
        self.init()
        self.id = model?.id
        self.localizedName = model?.localizedName
        self.englishName = model?.englishName
        self.level = model?.level
        self.localizedType = model?.localizedType
        self.englishType = model?.englishType
        self.countryID = model?.countryID
    }
}

// MARK: - Country
class CountryEntity: EmbeddedObject {
    @Persisted var id: String?
    @Persisted var localizedName: String?
    @Persisted var englishName: String?

    convenience init(model: Country?) {
        self.init()
        self.id = model?.id
        self.localizedName = model?.localizedName
        self.englishName = model?.englishName
    }
}

// MARK: - GeoPosition
class GeoPositionEntity: EmbeddedObject {
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    
    convenience init(model: GeoPosition?) {
        self.init()
        self.latitude = model?.latitude
        self.longitude = model?.longitude
    }
}

// MARK: - ParentCity
class ParentCityEntity: EmbeddedObject {
    @Persisted var key: String?
    @Persisted var localizedName: String?
    @Persisted var englishName: String?
    
    convenience init(model: ParentCity?) {
        self.init()
        self.key = model?.key
        self.localizedName = model?.localizedName
        self.englishName = model?.englishName
    }
}

// MARK: - SupplementalAdminArea
class SupplementalAdminAreaEntity: EmbeddedObject {
    @Persisted var level: Int?
    @Persisted var localizedName: String?
    @Persisted var englishName: String?
    
    convenience init(model: SupplementalAdminArea?) {
        self.init()
        self.level = model?.level
        self.localizedName = model?.localizedName
        self.englishName = model?.englishName
    }
}

// MARK: - TimeZone
class TimeZoneEntity: EmbeddedObject {
    @Persisted var code: String?
    @Persisted var name: String?
    @Persisted var gmtOffset: Double?
    @Persisted var isDaylightSaving: Bool?
    
    convenience init(model: TimeZone?) {
        self.init()
        self.code = model?.code
        self.name = model?.name
        self.gmtOffset = model?.gmtOffset
        self.isDaylightSaving = model?.isDaylightSaving
    }
}
