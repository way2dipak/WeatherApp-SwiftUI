//
//  FiveDayForecastView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 07/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct WeatherForecastWidgetView: View {
    let weatherDetails: FiveDayForecastModelEntity?//FiveDayWeatherModel?
    let currentTemp: Double?
    
    @Binding var opacityVal: CGFloat
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(interpolatedBackgroundColor(alphaOffset: opacityVal))
                .blur(radius: 0.4)
            
            VStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "calendar.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                        
                        Text("5-day forecast")
                            .scaledFont(weight: .medium, size: 16)
                            .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                        
                        Spacer()
                        
                        Button(action: {
                            router.push(.webView(weatherDetails?.headline?.mobileLink ?? ""))
                        }) {
                            HStack(alignment: .center, spacing: 10) {
                                Text("More details")
                                    .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                                    .scaledFont(weight: .medium, size: 12)
                                Image(systemName: "arrowtriangle.forward.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    
                    ForEach(weatherDetails?.getForecastLimit(value: 3) ?? []) { details in
                        let lastItem = weatherDetails?.getForecastLimit(value: 3)?.last
                        ForcastDayView(currentTemp: currentTemp, weatherDetails: details, opacityVal: opacityVal)
                        
                        if details.id != lastItem?.id {
                            Divider()
                                .background(.white.opacity(0.1))
                                .frame(height: 0.5)
                        }
                    }
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            print("Capsule Button Tapped")
                        }) {
                            Text("5-day forecast")
                                .scaledFont(weight: .medium, size: 16)
                                .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                                .padding(.vertical)
                                .padding(.horizontal, 90)
                                .frame(height: 40, alignment: .center)
                                .background(whiteToGrayColor(alphaOffset: opacityVal))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    
}

struct ForcastDayView: View {
    
    var currentTemp: Double?
    let weatherDetails: DailyForecastEntity?
    var opacityVal: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 10) {
                    Text(weatherDetails?.epochDate?.convertToWeekName() ?? "")
                        .scaledFont(weight: .medium, size: 16)
                        //.foregroundColor(.white)
                        .foregroundColor(interpolatedTextColor(alphaOffset: opacityVal))
                    Spacer()
                    if let iconLink = weatherDetails?.iconLink, let url = URL(string: iconLink) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                    TemperatureRangeBarView(minTemp: weatherDetails?.getMinTemp() ?? 0,
                                            maxTemp: weatherDetails?.getMaxTemp() ?? 0,
                                            currentTemp: currentTemp ?? 0,
                                            opacityVal: opacityVal,
                                            isToday: weatherDetails?.isToday ?? false)
                        .frame(width: kDeviceSize.width * 0.4)
                }
            }
            .padding(.vertical, 10)
            //.padding(.horizontal, 20)
        }
    }
}

struct FiveDayForecastView_Previews: PreviewProvider {
    static var previews: some View {
        //ApiMock.getForecastJson()
        WeatherForecastWidgetView(weatherDetails: nil,
                                  currentTemp: 0,
                                  opacityVal: .constant(1))
            .preferredColorScheme(.dark)
    }
}
