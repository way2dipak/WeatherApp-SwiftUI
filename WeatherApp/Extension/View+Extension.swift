//
//  View+Extension.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity,
                   alignment: alignment)
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity,
                   alignment: alignment)
    }
}
