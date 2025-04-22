//
//  AppEnvironment.swift
//  NewsApp
//
//  Created by Dipak Singh on 02/01/25.
//

import Foundation

public struct APIBase {
    public static var currentEnv: AppEnvironment = .development
}

public enum AppEnvironment {
    case development

    public var baseUrl: String {
        switch self {
        case .development:
            return "http://dataservice.accuweather.com"
        }
    }
    
    public var host: String {
        switch self {
        case .development:
            return "dataservice.accuweather.com"
        }
    }
    
    static func getEnvironment(value: String) -> AppEnvironment {
        switch value.lowercased() {
        case "development":
            return .development
        default:
            return .development
        }
    }
}
