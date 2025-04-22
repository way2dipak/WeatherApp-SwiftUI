//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 07/02/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(AppStorageKey.tempUnits.rawValue) private var tempUnits: TemperatureUnits = .celsius
    @AppStorage(AppStorageKey.windSpeedUnits.rawValue) private var windSpeedUnits: WindSpeedUnits = .kilometersPerHour
    @AppStorage(AppStorageKey.atmosphericPressureUnits.rawValue) private var atmosphericPressureUnits: PressureUnits =
        .millibar
    @AppStorage(AppStorageKey.appLocale.rawValue) private var appLocale: Language = .english
    @AppStorage(AppStorageKey.backgroundStyle.rawValue) private var backgroudStyle: BackgroundStyle = .none
    @AppStorage(AppStorageKey.dataSavingMode.rawValue) private var dataSavingMode: Bool = true
    @AppStorage(AppStorageKey.widgetUpdate.rawValue) private var widgetUpdateFrequency: UpdateFrequency = .hourly
    @AppStorage(AppStorageKey.mockData.rawValue) private var useMockData: Bool = true
    @AppStorage(AppStorageKey.fetchInterval.rawValue) private var apiUpdateFrequency: UpdateFrequency = .minutes5
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            Form {
                unitsSectionView
                apperanceSectionView
                preferenceSectionView
                aboutSectionView
            }
        }
        .navigationBarTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                }
                
            }
        }
    }
    
    private var unitsSectionView: some View {
        Section(header: Text("Units")) {
            Group {
                Picker("Temperature units", selection: $tempUnits) {
                    ForEach(TemperatureUnits.allCases) { details in
                        Text(details.rawValue.capitalized)
                            .tag(details)
                    }
                }
                Picker("Wind speed units", selection: $windSpeedUnits) {
                    ForEach(WindSpeedUnits.allCases) { details in
                        Text(details.rawValue.capitalized)
                            .tag(details)
                    }
                }
                Picker("Atmospheric pressure units", selection: $atmosphericPressureUnits) {
                    ForEach(PressureUnits.allCases) { details in
                        Text(details.rawValue.capitalized)
                            .tag(details)
                    }
                }
            }
            .padding(.vertical, 10)
        }
        
    }
    
    private var apperanceSectionView: some View {
        Section(header: Text("Appearance")) {
            Group {
                Picker("Language", selection: $appLocale) {
                    ForEach(Language.allCases) { details in
                        Text(details.rawValue.capitalized)
                            .tag(details)
                    }
                }
                Picker("Background style", selection: $backgroudStyle) {
                    ForEach(BackgroundStyle.allCases) { details in
                        Text(details.rawValue.capitalized)
                            .tag(details)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    private var preferenceSectionView: some View {
        Section(header: Text("Preferences")) {
            Group {
                Toggle("Mock data", isOn: $useMockData)
                    .onChange(of: useMockData) {
                        let _ = print(useMockData)
                        //useMockData = !useMockData
                    }
                Picker("Weather update\nfrequency", selection: $apiUpdateFrequency) {
                    ForEach(UpdateFrequency.allCases) { details in
                        Text(details.rawValue)
                            .tag(details)
                    }
                }
                Toggle("Data saving mode", isOn: $dataSavingMode)
                    .onChange(of: dataSavingMode) {
                        if dataSavingMode {
                            if widgetUpdateFrequency != .hourly {
                                widgetUpdateFrequency = .hourly
                            }
                        }
                    }
                Picker("Widget update\nfrequency", selection: $widgetUpdateFrequency) {
                    ForEach(UpdateFrequency.allCases) { details in
                        Text(details.rawValue)
                            .tag(details)
                    }
                }
                .disabled(dataSavingMode)
            }
            .padding(.vertical, 10)
        }
    }
    
    private var aboutSectionView: some View {
        Section(header: Text("About")) {
            Group {
                NavigationLink("Privacy policy") {
                        PrivacyPolicyView()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
                .environmentObject(Router())
}
