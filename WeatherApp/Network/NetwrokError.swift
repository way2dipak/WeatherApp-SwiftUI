//
//  NetwrokError.swift
//  NewsApp
//
//  Created by Dipak Singh on 02/01/25.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

public enum NetworkError: Error {
    case noResponse
    case unauthorized
    case httpError(Int)
    case noData
    case decodingError(Error)
    case custom(String)
    
    static func map(_ error: URLError) -> NetworkError {
        return .custom(error.localizedDescription)
    }
    
    var localizedDescription: String {
        switch self {
        case .noResponse: return "No response from server."
        case .unauthorized: return "Unauthorized. Please log in again."
        case .httpError(let code): return "HTTP error with code \(code)."
        case .noData: return "No data received."
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .custom(let message): return message.debugDescription
        }
    }
}

