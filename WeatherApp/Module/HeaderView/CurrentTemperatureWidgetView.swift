//
//  TemperatureHeaderView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/10/23.
//

import SwiftUI

struct CurrentTemperatureWidgetView: View {
    let weatherDetails: CurrentWeatherModelEntity?
    let currentPage: Int?
    let totalPages: Int?
    let cityName: String?
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 8) {
                CityNameView(currentPage: currentPage,
                             totalPages: totalPages,
                             cityName: cityName)
                Text(weatherDetails?.getCurrentTemperature() ?? "")
                    .scaledFont(weight: .light, size: 120)
                    .foregroundColor(.white)
                    .padding(.leading, -5)
                
                Text("\(weatherDetails?.weatherText ?? "")  \(weatherDetails?.getMinMaxTemp() ?? "")")
                    .scaledFont(weight: .medium, size: 16)
                    .foregroundColor(.white)
            }
            .hSpacing(.leading)
        }
    }
}

struct TemperatureHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTemperatureWidgetView(weatherDetails: nil,
                                     currentPage: 0,
                                     totalPages: 0,
                                     cityName: nil)
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
