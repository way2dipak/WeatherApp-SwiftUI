//
//  CityView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 03/10/23.
//

import SwiftUI

struct CityWeatherView: View {
    
    var details: CurrentWeatherModelEntity?
    var location: GeoPositionModelEntity?
    var isDefaultLocation: Bool = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 10) {
                        Text(location?.getCityName() ?? "Mahadevapura")
                            .scaledFont(weight: .regular, size: 18)
                            .foregroundColor(.white)
                        
                        if isDefaultLocation {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                    }
                    HStack(alignment: .center, spacing: 16) {
                        Text(details?.weatherText ?? "")
                            .scaledFont(weight: .regular, size: 14)
                            .foregroundColor(.white.opacity(0.7))
                        Text(details?.getMinMaxTemp() ?? "")
                            .scaledFont(weight: .regular, size: 14)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.vertical, 20)
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(details?.getCurrentTemperature() ?? "NA")°")
                        .scaledFont(weight: .regular, size: 26)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .background(.blue.opacity(0.6))
            .hSpacing(.leading)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        //ApiMock.getCurrentWeatherJson()
        CityWeatherView(details: nil,
                        isDefaultLocation: true)
        .preferredColorScheme(.dark)
    }
}
