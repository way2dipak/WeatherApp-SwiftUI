//
//  APIRequest.swift
//  NewsApp
//
//  Created by Dipak Singh on 02/01/25.
//

import Foundation

import UIKit

public struct APIRequest {
    var baseURL: String = ""
    var path: String
    var method: HTTPMethod
    var headers: [String: String]
    var queryParams: [String: Any]
    var params: [String: Any]
    var token: String?
    var encodeURL: Bool
    var showExceptional: Bool = false
    
    init(baseURL: String = "",
         path: String,
         method: HTTPMethod,
         headers: [String: String] = [:],
         queryParams: [String: Any] = [:],
         params: [String: Any] = [:],
         token: String? = nil,
         showExceptional: Bool = false) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParams = queryParams
        self.params = params
        self.token = token
        self.encodeURL = true
        self.showExceptional = showExceptional
    }
    
    func constructURLRequest() -> URLRequest {
        let url = ((baseURL != "" ? baseURL : APIBase.currentEnv.baseUrl) + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL != "" ? baseURL : APIBase.currentEnv.host
        components.path = "/" + path
        var newQuery: [String: Any] = [:]
        newQuery = queryParams
        newQuery["apikey"] = apiKey
        newQuery["language"] = Language(rawValue: UserDefaults.standard.string(forKey: AppStorageKey.appLocale.rawValue) ?? "English")?.localeShortHand ?? "en-us"
        if !newQuery.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in newQuery {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        var urlRequest = URLRequest(url: URL(string: components.url == nil ? url : components.url?.absoluteString ?? "")!, timeoutInterval: 60)
        var newHeaders: [String: String] = [:]
        if headers.count != 0 {
            newHeaders = headers
        } else {
            newHeaders = ["Content-Type": "application/json"]
        }
        urlRequest.allHTTPHeaderFields = newHeaders
        if method == .POST || method == .PATCH || method == .DELETE {
            if !params.isEmpty {
                let postData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = postData
            }
        }
        urlRequest.httpMethod = method.rawValue
        print(urlRequest.cURLString)
        return urlRequest
    }
}

extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var cURLString: String {
        guard let url = url else { return "" }
#if swift(>=5.0)
        var baseCommand = #"curl "\#(url.absoluteString)""#
#else
        var baseCommand = "curl \"\(url.absoluteString)\""
#endif
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
}
