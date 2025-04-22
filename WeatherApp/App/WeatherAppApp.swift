//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/10/23.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @StateObject var router = Router()
    
    init() {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("App Documents Directory: \(path)")
        }
        if UserDefaults.standard.value(forKey: AppStorageKey.fetchInterval.rawValue) == nil {
            UserDefaults.standard.set(UpdateFrequency.hourly.rawValue, forKey: AppStorageKey.fetchInterval.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView()
                .environmentObject(router)
        }
    }
}
