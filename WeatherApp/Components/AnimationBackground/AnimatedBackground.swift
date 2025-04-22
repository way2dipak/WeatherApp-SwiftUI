//
//  AnimatedBackground.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI

enum PrecipitationType {
    case rain, snow, hail
}

enum CloudType {
    case clear
    case few
    case scattered
    case broken
    case overcast
}

func animatedBackground(for weatherIcon: Int) -> some View {
    let isDay = isDayTime
    
    switch weatherIcon {
        case 1, 2, 31: // ☀️ Sunny / Mostly Sunny / Hot
            return AnyView(SkyView(day: isDay, cloudiness: .clear))
            
        case 3, 4, 32: // ⛅️ Partly Sunny / Intermittent Clouds / Hazy Sunshine / Windy
            return AnyView(SkyView(day: isDay, cloudiness: .few))
            
        case 5: // 🌫 Hazy
            return AnyView(HazyView())
            
        case 6, 7, 38: // 🌥 Mostly Cloudy / Cloudy / Mostly Cloudy (Night)
            return AnyView(SkyView(day: isDay, cloudiness: .scattered))
            
        case 8, 30: // ☁️ Overcast / Cold
            return AnyView(SkyView(day: isDay, cloudiness: .broken))
            
        case 11: // 🌫 Fog
            return AnyView(FoggyView())
            
        case 12, 13, 14, 39, 40: // 🌧 Showers / Mostly Cloudy with Showers
        return AnyView(
            RainyView(
                raindrops: Raindrop.generateRain(intensity: 50),
                isThunder: false,
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 250)
            )
        )
            
        case 15, 16, 17, 41, 42: // ⛈ Thunderstorms / Mostly Cloudy with Thunderstorms
        return AnyView(
            RainyView(
                raindrops: Raindrop.generateRain(intensity: 300),
                isThunder: true,
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 300)
            )
        )
            
        case 18: // 🌧 Rain
        return AnyView(
            RainyView(
                raindrops: Raindrop.generateRain(intensity: 300),
                isThunder: false,
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 100)
            )
        )
            
        case 19, 20, 21, 29: // 🌨 Flurries / Rain and Snow
        return AnyView(
            SnowyView(
                snowFlakes: SnowFlakesModel.generateSnow(intensity: 150),
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 100)
            )
        )
            
        case 22, 23, 43, 44: // ❄️ Snow / Night Snow
        return AnyView(
            SnowyView(
                snowFlakes: SnowFlakesModel.generateSnow(intensity: 150),
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 300)
            )
        )
            
        case 24, 25, 26: // 🌨 Ice, Sleet, Freezing Rain
        return AnyView(
            RainyView(
                raindrops: Raindrop.generateRain(intensity: 250),
                isThunder: false,
                isCloudiness: true,
                clouds: Cloud.generateClouds(count: 400)
            )
        )
            
        case 33, 34: // 🌙 Clear / Mostly Clear (Night)
            return AnyView(SkyView(day: false, cloudiness: .clear))
            
        case 35, 36, 37: // 🌙 Partly Cloudy / Intermittent Clouds / Hazy Moonlight
            return AnyView(SkyView(day: false, cloudiness: .few))
            
        default:
            return AnyView(Color.clear)
    }
}

// Example Usage
#Preview {
    animatedBackground(for: 11)
}


