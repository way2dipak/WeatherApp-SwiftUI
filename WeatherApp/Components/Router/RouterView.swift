//
//  RouterView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 07/02/25.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path: [Route] = [] // Stack of routes
    @Published var showNavigationBar: Bool = true
    @Published var useLargeTitle: Bool = true
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func setNavigationBar(hidden: Bool) {
        showNavigationBar = !hidden
    }
    
    func setLargeTitle(enabled: Bool) {
        useLargeTitle = enabled
    }
}

enum Route: Hashable {
    case home
    case search
    case settings
    case privacyPolicy
    case webView(String)
}

struct RouterView: View {
    @StateObject var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LaunchView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .search:
                        ManageCityView()
                    case .settings:
                        SettingsView()
                    case .privacyPolicy:
                        PrivacyPolicyView()
                    case .webView(let link):
                        WebView(link: link)
                    }
                }
                
        }
        .environmentObject(router)
    }
}
