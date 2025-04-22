//
//  WebView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 17/02/25.
//

import SwiftUI

struct WebView: View {
    var link: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            WebViewRepresentable(urlString: link)
                .ignoresSafeArea(.all)
        }
        .navigationBarTitle("")
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
}

#Preview {
    WebView(link: "https://www.google.com")
        .preferredColorScheme(.dark)
}
