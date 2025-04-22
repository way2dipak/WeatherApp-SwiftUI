//
//  BackgroundView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/10/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        let colors = [
            Color(hex: "01162E"),
            Color(hex: "001D37"),
            Color(hex: "002746"),
            Color(hex: "013155"),
            Color(hex: "003A63"),
            Color(hex: "01426D")
]
        ZStack {
            LinearGradient(colors: colors.reversed(),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
//            Image("cloud2")
//                .resizable()
//                .scaledToFill()
            
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}

extension Color {
    /// Creates a color from a hexadecimal value.
    ///
    /// - Parameters:
    ///   - hex: The hexadecimal value of the color (e.g., 0xFF0000 for red).
    ///   - opacity: The opacity of the color, ranging from 0.0 to 1.0 (default is 1.0).
    init(hex: String, opacity: Double = 1.0) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, opacity: opacity)
        }
}
