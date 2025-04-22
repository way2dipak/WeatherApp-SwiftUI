//
//  HomeView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 22/10/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var vwModel = HomeViewModel()
    
    @State private var scrollOffset: CGFloat = 0
    @State private var displayCityName: Bool = false
    @State private var alphaOffset: CGFloat = isDayTime ? 1 : 0.1
    @State private var selectedPage = -1
    @State private var scrollToID: Int? = nil
    @State private var currentBackground: AnyView = AnyView(Color.clear)
    
    @EnvironmentObject var router: Router
    
    private let triggerOffset: CGFloat = 50
    
    var body: some View {
        ZStack {
                currentBackground
            VStack {
                if vwModel.homeData.isEmpty {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    NavbarView(isCityNameRequired: $displayCityName,
                               cityName: vwModel.homeData[selectedPage].geoPosition?.getCityName() ?? "",
                               currentPage: selectedPage,
                               totalPage: vwModel.homeData.count)
                    .environmentObject(router)
                    
                    TabView(selection: $selectedPage) {
                        ForEach(0..<vwModel.homeData.count, id: \.self) { index in
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading) {
                                    GeometryReader { proxy in
                                        let yOffset = proxy.frame(in: .global).minY
                                        let _ = print("yOffset: \(yOffset)")
                                        HStack(alignment: .center) {
                                            Spacer()
                                            CurrentTemperatureWidgetView(
                                                weatherDetails: vwModel.currentWeatherDetails,
                                                currentPage: selectedPage,
                                                totalPages: vwModel.homeData.count,
                                                cityName: vwModel.homeData[index].geoPosition?.getCityName()
                                            )
                                            .padding(.top, 50)
                                            .padding(.horizontal, 20)
                                            .opacity(opacity(for: yOffset, threshold: triggerOffset))
                                            .padding(.top, 20)
                                            .onAppear {
                                                //scrollOffset = 0
                                            }
                                            .onChange(of: yOffset) { _, newValue in
                                                //withAnimation(.linear(duration: 0.1)) {
                                                    self.scrollOffset = yOffset
                                                    self.scrollToID = Int(newValue / 50)
                                                    self.displayCityName = yOffset < 18
                                                    //self.alphaOffset = max(0, min(1, 1 - ((yOffset + 100) / 200)))
                                                //}
                                            }
                                        }
                                        Spacer()
                                    }
                                    
                                    LazyVStack(alignment: .center, spacing: 20) {
                                        VStack(alignment: .center) {
                                            WeatherForecastWidgetView(
                                                weatherDetails: vwModel.fiveDaysWeatherDetails,
                                                currentTemp: vwModel.currentWeatherDetails?.temperature?.metric?.value ?? 0,
                                                opacityVal: $alphaOffset
                                            )
                                            .environmentObject(router)
                                        }
                                        .padding(.top, (kDeviceSize.height * 0.45))
                                        .padding(.horizontal, 16)
                                        
                                        HourlyWeatherWidgetView(
                                            forecasts: vwModel.hourlyWeatherDetails ?? [],
                                            opacityVal: alphaOffset
                                        )
                                        .padding(.horizontal, 16)
                                        
                                        WidgetView(currentWeatherDetails: vwModel.currentWeatherDetails,
                                                   alphaOffset: alphaOffset)
                                        .padding(.horizontal, 16)
                                        
                                        Group {
                                            HStack(alignment: .center, spacing: 5) {
                                                Text("Data Provided in part by")
                                                    .scaledFont(weight: .medium, size: 12)
                                                    .foregroundColor(.gray)
                                                Image("AccuWeather")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 15)
                                                    .foregroundColor(isDayTime ? .black : .yellow)
                                            }
                                        }
                                        .padding(.top, 20)
                                    }
                                }
                                .padding(.vertical, 10)
                            }.refreshable(action: {
                                self.vwModel.fetchWeatherDetails(isForceUpdate: true)
                            })
                            
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .onChange(of: selectedPage, { oldValue, newValue in
                vwModel.updateCurrentDetails(for: newValue)
                currentBackground = AnyView(Color.clear)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                currentBackground = animatedBackground(for: vwModel.getCurrentWatherIcon(for: newValue)) as! AnyView
                }
            })
            .onAppear {
                selectedPage = 0
                vwModel.currentWeatherDetails = nil
                vwModel.fetchWeatherDetails()
                currentBackground = animatedBackground(for: vwModel.getCurrentWatherIcon(for: selectedPage)) as! AnyView
            }
            .padding(.top, 0)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func opacity(for offset: CGFloat, threshold: CGFloat) -> Double {
        let normalizedOffset = max(0, min(1, -(offset) / threshold))
        return Double(1 - normalizedOffset)
    }
}
