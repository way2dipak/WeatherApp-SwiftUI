//
//  WeatherWidgetView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 05/02/25.
//

import SwiftUI

enum WidgetType {
    case UVWidget
    case HumidityWidget
    case RealFeelWidget
    case WindDirection
    case CloudCoverageWidget
    case PressureWidget
}

struct WeatherWidgetView: View {
    
    var type: WidgetType
    var currentWeatherDetails: CurrentWeatherModelEntity?//CurrentWeatherModel?
    
    var opacityVal: CGFloat = 0.1
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Text(getTitle())
                    .scaledFont(weight: .regular, size: 16)
                    .foregroundColor(.gray)
                
                Text(getSubTitle())
                    .scaledFont(weight: .regular, size: 26)
                    //.foregroundColor(.white.opacity(0.8))
                    .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
            
            }
            .padding(.vertical, 20)
            
            HStack {
                Spacer()
                switch type {
                case .UVWidget:
                    UVProgressView(progress: currentWeatherDetails?.getUVIndexProgress() ?? 0, displayValue: "\(currentWeatherDetails?.uvIndex ?? 0)")
                case .HumidityWidget:
                    HumidityProgressView(progress: (Double(currentWeatherDetails?.relativeHumidity ?? 0)/100))
                case .RealFeelWidget:
                    RealFeelProgressView(progress: currentWeatherDetails?.getRealFeelProgress() ?? 0)
                case .WindDirection:
                    CompassView(degreeVal: Double(currentWeatherDetails?.wind?.direction?.degrees ?? 0), unit: "\(currentWeatherDetails?.wind?.speed?.metric?.unit ?? "")")
                case .CloudCoverageWidget:
                    let progress = (Double(currentWeatherDetails?.cloudCover ?? 0) / 100) + 0.1
                CloudCoverageProgressView(progress: progress)
                case .PressureWidget:
                    
                    let pressure: Double = currentWeatherDetails?.pressure?.metric?.value ?? 0
                    let code: String = currentWeatherDetails?.pressureTendency?.code ?? ""
                    let unit: String = currentWeatherDetails?.pressure?.metric?.unit ?? ""
                    let minPressure: Double = 970
                    let maxPressure: Double = 1050
                    let value = ((pressure - minPressure) / (maxPressure - minPressure)) * (0.9 - 0.1)
                    PressureProgressView(progress: min(max(value, 0.1), 0.9), code: code, unit: unit)
                }
            }
            .padding(.bottom, 20)
        }
        .hSpacing(.leading)
        .padding(.horizontal, 20)
        .background(interpolatedBackgroundColor(alphaOffset: opacityVal))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    func getProgressValue(minTemp: Double, maxTemp: Double, currentTemp: Double) -> Double {
        let progress = (currentTemp - minTemp) / (maxTemp - minTemp) // Normal progress (0 to 1)
        return 0.1 + (progress * 0.8)
    }
    
    private func getTitle() -> String {
        switch type {
        case .UVWidget:
            return "UV"
        case .HumidityWidget:
            return "Humidity"
        case .RealFeelWidget:
            return "Real feel"
        case .WindDirection:
            return windDirectionMap[currentWeatherDetails?.wind?.direction?.english ?? ""] ?? ""
        case .CloudCoverageWidget:
            return "Cloud Coverage"
        case .PressureWidget:
            return "Pressure"
        }
    }
    
    private func getSubTitle() -> String {
        switch type {
        case .UVWidget:
            return currentWeatherDetails?.uvIndexText ?? ""
        case .HumidityWidget:
            return "\(currentWeatherDetails?.relativeHumidity ?? 0)%"
        case .RealFeelWidget:
            return "\(currentWeatherDetails?.realFeelTemperature?.metric?.value?.roundeValue() ?? "")°"
        case .WindDirection:
            return "\(currentWeatherDetails?.wind?.speed?.metric?.value?.roundeValue() ?? "")"
        case .CloudCoverageWidget:
            return "\(currentWeatherDetails?.cloudCover ?? 0)%"
        case .PressureWidget:
            return "\(currentWeatherDetails?.pressure?.metric?.value?.roundeValue() ?? "")"
        }
    }
}

#Preview {
    //ApiMock.getCurrentWeatherJson()
    WeatherWidgetView(type: .RealFeelWidget,
                      currentWeatherDetails: nil)
            .preferredColorScheme(.dark)
}

