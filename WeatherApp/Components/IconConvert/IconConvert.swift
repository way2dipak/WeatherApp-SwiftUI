//
//  IconConvert.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI

let iconMap: [String: String] = [
    "1": "sunny",                              // Sunny
    "2": "mostly_sunny",                       // Mostly Sunny
    "3": "partly_cloudy",                      // Partly Sunny
    "4": "clouds",                             // Intermittent Clouds
    "5": "haze_fog_dust_smoke",                // Hazy Sunshine
    "6": "mostly_cloudy_day",                  // Mostly Cloudy
    "7": "cloudy",                             // Cloudy
    "8": "cloudy",                             // Dreary (Overcast)
    "11": "haze_fog_dust_smoke",               // Fog
    "12": "showers_rain",                      // Showers
    "13": "mostly_cloudy_day",                 // Mostly Cloudy with Showers
    "14": "partly_cloudy",                     // Partly Sunny with Showers
    "15": "strong_tstorms",                    // Thunderstorms
    "16": "isolated_scattered_tstorms_day",    // Mostly Cloudy with Thunderstorms
    "17": "isolated_scattered_tstorms_day",    // Partly Sunny with Thunderstorms
    "18": "heavy_rain",                        // Rain
    "19": "flurries",                          // Flurries
    "20": "mostly_cloudy_day",                 // Mostly Cloudy with Flurries
    "21": "partly_cloudy",                     // Partly Sunny with Flurries
    "22": "snow_showers_snow",                 // Snow
    "23": "mostly_cloudy_day",                 // Mostly Cloudy with Snow
    "24": "sleet_hail",                        // Ice
    "25": "sleet_hail",                        // Sleet
    "26": "wintry_mix_rain_snow",              // Freezing Rain
    "29": "wintry_mix_rain_snow",              // Rain and Snow
    "30": "clear_night",                       // Cold
    "31": "clear_night",                       // Hot
    "32": "clouds",                            // Windy
    "33": "clear_night",                       // Clear (Night)
    "34": "mostly_clear_night",                // Mostly Clear (Night)
    "35": "partly_cloudy_night",               // Partly Cloudy (Night)
    "36": "partly_cloudy_night",               // Intermittent Clouds (Night)
    "37": "haze_fog_dust_smoke",               // Hazy Moonlight
    "38": "mostly_cloudy_night",               // Mostly Cloudy (Night)
    "39": "scattered_showers_night",           // Partly Cloudy with Showers (Night)
    "40": "scattered_showers_night",           // Mostly Cloudy with Showers (Night)
    "41": "isolated_scattered_tstorms_night",  // Partly Cloudy with Thunderstorms (Night)
    "42": "isolated_scattered_tstorms_night",  // Mostly Cloudy with Thunderstorms (Night)
    "43": "snow_showers_snow",                 // Mostly Cloudy with Flurries (Night)
    "44": "snow_showers_snow"                  // Mostly Cloudy with Snow (Night)
]

let openWeatherMappedIcon: [String: String] = [
    "1": "01d",  // Sunny
    "2": "01d",  // Mostly Sunny
    "3": "02d",  // Partly Sunny
    "4": "02d",  // Intermittent Clouds
    "5": "50d",  // Hazy Sunshine
    "6": "03d",  // Mostly Cloudy
    "7": "03d",  // Cloudy
    "8": "04d",  // Overcast
    "11": "50d", // Fog
    "12": "09d", // Light Showers
    "13": "09d", // Mostly Cloudy with Light Showers
    "14": "09d", // Partly Sunny with Light Showers
    "15": "11d", // Thunderstorms
    "16": "11d", // Mostly Cloudy with Thunderstorms
    "17": "11d", // Partly Sunny with Thunderstorms
    "18": "10d", // Moderate/Heavy Rain
    "19": "13d", // Light Snow/Flurries
    "20": "13d", // Mostly Cloudy with Light Snow
    "21": "13d", // Partly Sunny with Light Snow
    "22": "13d", // Snow
    "23": "13d", // Mostly Cloudy with Snow
    "24": "13d", // Ice (No exact match in OpenWeather)
    "25": "13d", // Sleet (Closest is Snow)
    "26": "13d", // Freezing Rain
    "29": "13d", // Rain and Snow Mix
    "30": "50d", // Cold (Closest is Haze)
    "31": "01d", // Hot (No exact match, using sunny)
    "32": "50d", // Windy (Closest is Haze)
    "33": "01n", // Clear Night
    "34": "01n", // Mostly Clear Night
    "35": "02n", // Partly Cloudy Night
    "36": "02n", // Intermittent Clouds Night
    "37": "50n", // Hazy Moonlight
    "38": "03n", // Mostly Cloudy Night
    "39": "09n", // Partly Cloudy with Showers Night
    "40": "09n", // Mostly Cloudy with Showers Night
    "41": "11n", // Partly Cloudy with Thunderstorms Night
    "42": "11n", // Mostly Cloudy with Thunderstorms Night
    "43": "13n", // Mostly Cloudy with Flurries Night
    "44": "13n"  // Mostly Cloudy with Snow Night
]

let iconColorsMap: [String: [Color]] = [
    "1": [.yellow],                           // Sunny
    "2": [.yellow],                           // Mostly Sunny
    "3": [.white, .yellow],                  // Partly Sunny
    "4": [.white, .yellow],                  // Intermittent Clouds
    "5": [.white, .yellow],                  // Hazy Sunshine
    "6": [.white],                           // Mostly Cloudy
    "7": [.white],                           // Cloudy
    "8": [.gray],                             // Overcast
    "11": [.gray, .white],                   // Fog
    "12": [.white, .blue],                   // Showers
    "13": [.white, .yellow, .blue],          // Mostly Cloudy with Showers
    "14": [.white, .yellow, .blue],          // Partly Sunny with Showers
    "15": [.white, .blue],                   // Thunderstorms
    "16": [.white, .blue],                   // Mostly Cloudy with Thunderstorms
    "17": [.white, .yellow, .blue],          // Partly Sunny with Thunderstorms
    "18": [.white, .blue],                   // Rain
    "19": [.white, .gray],                   // Flurries
    "20": [.white, .gray],                   // Mostly Cloudy with Flurries
    "21": [.white, .gray],                   // Partly Sunny with Flurries
    "22": [.gray, .blue],                     // Snow
    "23": [.white, .gray],                   // Mostly Cloudy with Snow
    "24": [.gray, .blue],                     // Ice
    "25": [.gray, .blue],                     // Sleet
    "26": [.gray, .blue],                     // Freezing Rain
    "29": [.gray, .blue],                     // Rain and Snow
    "30": [.gray, .blue],                     // Cold
    "31": [.orange, .yellow],                 // Hot
    "32": [.gray],                            // Windy
    "33": [.gray, .white],                   // Clear (Night)
    "34": [.gray, .white],                   // Mostly Clear (Night)
    "35": [.gray, .white],                   // Partly Cloudy (Night)
    "36": [.gray, .white],                   // Intermittent Clouds (Night)
    "37": [.gray, .white],                   // Hazy Moonlight
    "38": [.gray, .white],                   // Mostly Cloudy (Night)
    "39": [.gray, .blue],                     // Partly Cloudy with Showers (Night)
    "40": [.gray, .blue],                     // Mostly Cloudy with Showers (Night)
    "41": [.gray, .blue],                     // Partly Cloudy with Thunderstorms (Night)
    "42": [.gray, .blue],                     // Mostly Cloudy with Thunderstorms (Night)
    "43": [.gray, .blue],                     // Mostly Cloudy with Flurries (Night)
    "44": [.gray, .blue]                      // Mostly Cloudy with Snow (Night)
]

func IconConvert(for iconName: String, useWeatherColors: Bool, primaryColor: Color? = nil, secondaryColor: Color? = nil, tertiaryColor: Color? = nil) -> some View {
    let sfSymbolName = iconMap[iconName] ?? iconName
    
    var colors: [Color] = []
    
    if useWeatherColors {
        if let primaryColor = primaryColor {
            colors.append(primaryColor)
        }
        if let secondaryColor = secondaryColor {
            colors.append(secondaryColor)
        }
        if let tertiaryColor = tertiaryColor {
            colors.append(tertiaryColor)
        }
        
        if colors.isEmpty {
            colors = iconColorsMap[iconName] ?? [.primary]
        }
    }
    
    let icon = Image(systemName: sfSymbolName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
    
    if useWeatherColors && !colors.isEmpty {
        let styledIcon: AnyView
        switch colors.count {
        case 1:
            styledIcon = AnyView(icon.symbolRenderingMode(.palette).foregroundStyle(colors[0]))
        case 2:
            styledIcon = AnyView(icon.symbolRenderingMode(.palette).foregroundStyle(colors[0], colors[1]))
        case 3:
            styledIcon = AnyView(icon.symbolRenderingMode(.palette).foregroundStyle(colors[0], colors[1], colors[2]))
        default:
            styledIcon = AnyView(icon.symbolRenderingMode(.palette).foregroundStyle(.primary))
        }
        return styledIcon
    } else {
        return AnyView(icon.foregroundStyle(.primary))
    }
}
