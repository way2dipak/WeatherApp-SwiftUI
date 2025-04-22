//
//  HourlyWeatherWidgetView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 03/02/25.
//

import SwiftUI
import Charts
import SDWebImageSwiftUI

struct HourlyWeatherWidgetView: View {
    let forecasts: [HourlyWeatherForecastModelEntity]
    var opacityVal: CGFloat = 0.1
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("12-hour forecast")
                .scaledFont(weight: .medium, size: 16)
                .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                .padding(.vertical, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Chart {
                    ForEach(forecasts, id: \.epochDateTime) { forecast in
                        let time = Date(timeIntervalSince1970: TimeInterval((forecast.epochDateTime ?? 0) + 400))
                        let temp = forecast.temperature?.value ?? 0
                        
                        LineMark(
                            x: .value("Time", time),
                            y: .value("Temperature", temp)
                        )
                        .foregroundStyle(Color.green)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        PointMark(
                            x: .value("Time", time),
                            y: .value("Temperature", temp)
                        )
                        .symbol {
                            if formatTimeHour(from: time) == formatTimeHour(from: Date()) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .annotation(position: .top, alignment: .center) {
                            VStack(alignment: .center, spacing: 5) {
                                Text("\((forecast.temperature?.value?.roundeValue() ?? ""))°")
                                    .scaledFont(weight: .medium, size: 12)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    if let nowTime = forecasts.first(where: { formatTimeHour(from: Date(timeIntervalSince1970: TimeInterval($0.epochDateTime ?? 0))) == formatTimeHour(from: Date()) }) {
                        RuleMark(x: .value("Time", Date(timeIntervalSince1970: TimeInterval((nowTime.epochDateTime ?? 0) + 400))))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2,2]))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .frame(width: CGFloat(forecasts.count * 60), height: 100)
                .chartYAxis(.hidden)
                .chartXAxis {
                    AxisMarks(values: forecasts.map { Date(timeIntervalSince1970: TimeInterval($0.epochDateTime ?? 0)) }) { value in
                        if let date = value.as(Date.self) {
                            let formattedTime = formatTimeHour(from: date) == formatTimeHour(from: Date()) ? "now" : formatTime(from: date)
                            
                            if let forecast = forecasts.first(where: { Date(timeIntervalSince1970: TimeInterval($0.epochDateTime ?? 0)) == date }) {
                                AxisValueLabel {
                                    VStack(alignment: .center, spacing: 5) {
                                        if let iconLink = URL(string: forecast.iconLink) {
                                            WebImage(url: iconLink)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                        }
                                        Text("\(forecast.wind?.speed?.value?.roundeValue() ?? "0") km/h")
                                            .scaledFont(weight: .regular, size: 10)
                                            .foregroundColor(.gray)
                                        
                                        Text(formattedTime)
                                            .scaledFont(weight: .regular, size: 10)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, -10)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
        .background(interpolatedBackgroundColor(alphaOffset: opacityVal))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

func getMinTemp(_ forecasts: [HourlyWeatherModel]) -> Double {
    forecasts.map { $0.temperature?.value ?? 0 }.min() ?? 0
}

/// ✅ Get the maximum temperature to properly scale the Y-axis
func getMaxTemp(_ forecasts: [HourlyWeatherModel]) -> Double {
    forecasts.map { $0.temperature?.value ?? 0 }.max() ?? 40
}

// MARK: - Helpers
func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh a" // Example: "05 AM"
    return formatter.string(from: date)
}

func formatTimeHour(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh a" // Example: "05 AM"
    return formatter.string(from: date)
}

func calculateYPosition(for temp: Double, in height: CGFloat) -> CGFloat {
    let minTemp = 10.0 // Adjust based on dataset
    let maxTemp = 30.0
    let normalized = (temp - minTemp) / (maxTemp - minTemp)
    return height * (1 - normalized) + 20
}

// MARK: - Preview
struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherWidgetView(forecasts: [])
            .preferredColorScheme(.dark)
    }
}

extension View {
    func debugLog(_ item: Any) -> some View {
#if DEBUG
        print(item)
#endif
        return self
    }
}
