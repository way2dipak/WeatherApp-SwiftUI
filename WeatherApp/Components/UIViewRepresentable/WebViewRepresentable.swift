//
//  WebViewRepresentable.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/02/25.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
}
