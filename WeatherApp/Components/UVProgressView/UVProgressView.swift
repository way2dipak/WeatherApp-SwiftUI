//
//  UVProgressView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 06/02/25.
//

import SwiftUI

struct UVProgressView: View {
    var progress: Double
    var displayValue: String
    
    let gradient = AngularGradient(
        gradient: Gradient(colors: [.green, .yellow, .orange, .red, .purple]),
        center: .center,
        startAngle: .degrees(44),
        endAngle: .degrees(344)
    )
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.1, to: 0.9)
                .stroke(gradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            Circle()
                .fill(.clear)
                .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(90))
                .frame(width: 9, height: 9)
                .offset(arcOffset(for: progress))
            
            Text(displayValue)
                .scaledFont(weight: .black, size: 18)
                .foregroundColor(isDayTime ? .black : .white)
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    //UVProgressView(progress: 0.1,
    //             displayValue: "33%")
    //CompassView(degreeVal: 90, unit: "Km/h")
    //PressureProgressView(progress: 0.43, code: "R", unit: "mb")
    RealFeelProgressView(progress: 0.65)
                .preferredColorScheme(.dark)
    
}

struct CompassView: View {
    var degreeVal: Double
    var unit: String
    
    var body: some View {
        ZStack {
                Image("compass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .foregroundColor(isDayTime ? .black : .white)
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
                    .rotationEffect(.degrees(degreeVal-90))
                    .foregroundColor(.blue)
            Text(unit)
                .foregroundStyle(.white)
                .scaledFont(weight: .medium, size: 8)
                .offset(x: 2)
        }
    }
}


struct HumidityProgressView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            let startVal = 0.1
            let endVal = (progress * 0.8) + 0.1
            Circle()
                .trim(from: 0.1, to: 0.9)
                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(90))
                Circle()
                    .trim(from: startVal, to: endVal)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(90))
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
        }
        .frame(width: 80, height: 80)
    }
}

struct RealFeelProgressView: View {
    var progress: Double
    let gradient = AngularGradient(
        gradient: Gradient(stops: [
            .init(color: .blue, location: 0.1),
            .init(color: .blue, location: 0.4),
            .init(color: .white, location: 0.4),
            .init(color: .white, location: 0.41),
            .init(color: .green, location: 0.41),
            .init(color: .green, location: 0.7),
            .init(color: .white, location: 0.7),
            .init(color: .white, location: 0.71),
            .init(color: .orange, location: 0.71),
            .init(color: .orange, location: 0.9)
        ]),
        center: .center,
        startAngle: .degrees(55),
        endAngle: .degrees(360)
    )
    
    var body: some View {
        ZStack {
            let startVal = 0.1
            let endVal = (0.9)
            //let endVal = (progress * 0.8)
            Circle()
                .trim(from: startVal, to: endVal)
                .stroke(gradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(90))
            Image(systemName: "arrow.down")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(getAngleValue(progress: progress)))
        }
        .frame(width: 80, height: 80)
    }
    
    func getAngleValue(progress: Double) -> Double {
        //return (progress * 144) + 90
        let clampedProgress = max(0.1, min(0.9, progress))
        let normalizedProgress = (clampedProgress - 0.1) / 0.8
        return 44 + ((normalizedProgress + 0.2) * 272)
    }
    
}


struct CloudCoverageProgressView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            let startVal = 0.1
            let endVal = (progress * 0.8)
            Circle()
                .trim(from: 0.1, to: 0.9)
                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(90))
                Circle()
                    .trim(from: startVal, to: endVal)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(90))
            Image(systemName: "cloud.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 28, height: 28)
            
        }
        .frame(width: 80, height: 80)
    }
}

struct PressureProgressView: View {
    var progress: Double
    var code: String
    var unit: String
    
    var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(90))
                Rectangle()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .fill(Color.blue)
                    .frame(width: 2, height: 10)
                    .rotationEffect(pressureArcRotation(for: progress))
                    .offset(pressureArcOffset(for: progress))
                    
                Text(unit)
                    .foregroundStyle(.gray)
                    .scaledFont(weight: .regular, size: 10)
                    .offset(y: 35)
                Image(systemName: code == "R" ? "arrow.up" : "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
            }
            .frame(width: 80, height: 80)
    }
    
    func pressureArcRotation(for value: Double) -> Angle {
        let clampedValue = max(0.1, min(0.8, value))
        let normalizedValue = (clampedValue - 0.1) / 0.8
        let angle = 44 + (normalizedValue * 300) //+ 90
        
        return Angle.degrees(angle)
    }
    
}
