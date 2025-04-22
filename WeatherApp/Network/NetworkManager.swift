//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Dipak Singh on 02/01/25.
//

import Foundation
import Combine

public final class NetworkManager {
    public static let shared = NetworkManager()
    private var session: URLSession
    private var subscriptions = Set<AnyCancellable>()
    private var isRefreshing = false
    private let refreshTokenSubject = PassthroughSubject<Void, Never>()
    
    // Replace with actual refresh token API logic
    private var refreshTokenPublisher: AnyPublisher<Void, NetworkError> {
        Future<Void, NetworkError> { promise in

            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                print("Token refreshed")
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    private init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: nil)
    }
    
    public func performRequest<T: Decodable>(
        request: APIRequest,
        retries: Int = 3,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, NetworkError> {
        let request = request.constructURLRequest()
        return session.dataTaskPublisher(for: request)
            .retryWithRefreshToken(
                maxRetries: retries,
                refreshPublisher: { self.refreshTokenPublisher }
            )
            .mapError { NetworkError.map($0) }
            .flatMap { (data, response) -> AnyPublisher<T, NetworkError> in
                self.validateResponse(response: response, data: data)
                    .tryMap({ data in
                        do {
                            return try decoder.decode(T.self, from: data)
                        } catch {
                            print("Decoding error: \(error)")
                            print("Response data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                            throw NetworkError.decodingError(error)
                        }
                    })
                //.decode(type: T.self, decoder: decoder)
                    .mapError { NetworkError.decodingError($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func validateResponse(response: URLResponse, data: Data) -> AnyPublisher<Data, NetworkError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return Fail(error: NetworkError.noResponse).eraseToAnyPublisher()
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                return Fail(error: NetworkError.unauthorized).eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.httpError(httpResponse.statusCode)).eraseToAnyPublisher()
            }
        }
        return Just(data).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
}


