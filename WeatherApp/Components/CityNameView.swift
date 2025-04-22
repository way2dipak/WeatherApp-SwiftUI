//
//  CityNameView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 03/02/25.
//

import SwiftUI

struct CityNameView: View {
    
    var currentPage: Int?
    let totalPages: Int?
    var cityName: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(cityName ?? "")
                .scaledFont(weight: .medium, size: 15)
                .foregroundColor(.white)
                .animation(.easeInOut(duration: 0.1))
                //.background(.green)
            HStack {
                ForEach(0..<(totalPages ?? 0), id: \.self) { pageIndex in
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(pageIndex == currentPage ? .white : .white.opacity(0.5))
                }
            }
        }
    }
}

#Preview {
    CityNameView(currentPage: 0, totalPages: 3)
}
