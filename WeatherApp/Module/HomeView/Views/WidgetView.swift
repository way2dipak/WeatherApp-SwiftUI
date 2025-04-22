//
//  WidgetView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 07/04/25.
//

import SwiftUI

struct WidgetView: View {
    var currentWeatherDetails: CurrentWeatherModelEntity?
    var alphaOffset: CGFloat = 0
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 15) {
                WeatherWidgetView(type: .UVWidget,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
                WeatherWidgetView(type: .HumidityWidget,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
            }
            HStack(alignment: .center, spacing: 15) {
                WeatherWidgetView(type: .RealFeelWidget,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
                WeatherWidgetView(type: .WindDirection,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
            }
            HStack(alignment: .center, spacing: 15) {
                WeatherWidgetView(type: .CloudCoverageWidget,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
                WeatherWidgetView(type: .PressureWidget,
                                  currentWeatherDetails: currentWeatherDetails,
                                  opacityVal: alphaOffset)
            }
        }
    }
}

#Preview {
    WidgetView()
}
