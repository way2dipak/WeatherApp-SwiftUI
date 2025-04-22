//
//  TemperatureRangeBarView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI

struct TemperatureRangeBarView: View {
    var minTemp: Double
    var maxTemp: Double
    var currentTemp: Double
    var opacityVal: CGFloat
    
    var isToday: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("\(minTemp.roundeValue())°")
                    .scaledFont(weight: .medium, size: 16)
                    .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        // Temperature Gradient Bar
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.orange, Color.red]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(height: 6)
                        .clipShape(Capsule())
                        
                        if isToday {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                .offset(x: positionForCurrentTemp(in: proxy.size.width))
                        }
                    }
                }
                .frame(height: 12)
                
                Text("\(maxTemp.roundeValue())°")
                    .scaledFont(weight: .medium, size: 16)
                    .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func positionForCurrentTemp(in width: CGFloat) -> CGFloat {
        let clampedTemp = min(max(currentTemp, minTemp), maxTemp)
        let percentage = (clampedTemp - minTemp) / (maxTemp - minTemp)
        return width * CGFloat(percentage) - 6
    }
}
#Preview {
    TemperatureRangeBarView(minTemp: 14,
                            maxTemp: 32,
                            currentTemp: 27,
                            opacityVal: 1)
}
