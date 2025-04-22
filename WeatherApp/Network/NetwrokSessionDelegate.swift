//
//  NetwrokSessionDelegate.swift
//  NewsApp
//
//  Created by Dipak Singh on 02/01/25.
//

import Foundation

final class NetworkSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let remoteCertificateData = SecCertificateCopyData(certificate) as Data
        
        guard let localCertPath = Bundle.main.path(forResource: "server", ofType: "cer"),
              let localCertificateData = try? Data(contentsOf: URL(fileURLWithPath: localCertPath)) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if remoteCertificateData == localCertificateData {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

