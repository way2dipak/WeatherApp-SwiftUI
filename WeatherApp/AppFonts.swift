//
//  AppFonts.swift
//  TheNews-SwiftUI
//
//  Created by Dipak Singh on 26/11/23.
//

import Foundation
import SwiftUI

enum AppFonts {
    
    static func thin(size: CGFloat) -> Font {
        return Font.custom("Roboto-Thin", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        return Font.custom("Roboto-Light", size: size)
    }
    
    static func regular(size: CGFloat) -> Font {
        return Font.custom("Roboto-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.custom("Roboto-Medium", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return Font.custom("Roboto-Bold", size: size)
    }
    
    static func black(size: CGFloat) -> Font {
        return Font.custom("Roboto-Black", size: size)
    }
}

enum FontWeight: String {
    case thin = "Thin"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
    case black = "Black"
}

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var weight: FontWeight
    var size: CGFloat = 16 // Default size

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        let font = AppFonts.font(for: weight, size: scaledSize)
        return content.font(font)
    }
}

extension AppFonts {
    static func font(for weight: FontWeight, size: CGFloat) -> Font {
        switch weight {
        case .thin:
            return thin(size: size)
        case .light:
            return light(size: size)
        case .regular:
            return regular(size: size)
        case .medium:
            return medium(size: size)
        case .bold:
            return bold(size: size)
        case .black:
            return black(size: size)
        }
    }
}

extension View {
    func scaledFont(weight: FontWeight, size: CGFloat = 16) -> some View {
        return self.modifier(ScaledFont(weight: weight, size: size))
    }
}
