//
//  NetworkManager+Extension.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import Foundation
import Combine

extension Publisher where Failure == URLError {
    func retryWithRefreshToken(
        maxRetries: Int,
        refreshPublisher: @escaping () -> AnyPublisher<Void, NetworkError>
    ) -> AnyPublisher<Output, Failure> {
        var retries = 0
        return self.catch { error -> AnyPublisher<Output, Failure> in
            guard retries < maxRetries else { return Fail(error: error).eraseToAnyPublisher() }
            retries += 1
            
            return refreshPublisher()
                .mapError { _ in error }
                .flatMap { _ in self }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

