//
//  ThunderstormView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI

private struct PrecipitationParticle: View {
    @State private var dropFall = false
    let type: PrecipitationType

    var body: some View {
        let size: CGSize
        let blurRadius: CGFloat
        
        switch type {
        case .rain:
            size = CGSize(width: 2, height: 50)
            blurRadius = 1
        case .snow:
            size = CGSize(width: 5, height: 5)
            blurRadius = 2
        case .hail:
            size = CGSize(width: 10, height: 10)
            blurRadius = 1
        }
        
        return Group {
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: size.width, height: size.height)
                .blur(radius: blurRadius)
                .offset(y: dropFall ? 800 : -800)
                .onAppear {
                    withAnimation(Animation.linear(duration: Double.random(in: 0.8...1.5)).repeatForever(autoreverses: false)) {
                        dropFall = true
                    }
                }
        }
    }
}

private struct PrecipitationView: View {
    let type: PrecipitationType
    let intensity: Int
    
    var body: some View {
        ZStack {
            ForEach(0..<intensity, id: \.self) { _ in
                PrecipitationParticle(type: type)
                    .offset(x: CGFloat.random(in: -200...200))
                    .animation(Animation.linear(duration: Double.random(in: 0.8...1.5)).repeatForever(autoreverses: false), value: UUID())
            }
        }
    }
}

private struct Lightning: View {
    @State private var showFlash = false
    @State private var currentFlashInterval: TimeInterval = Double.random(in: 5...12)
    let flashDuration: TimeInterval = 0.1
    
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(showFlash ? 0.8 : 0))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: currentFlashInterval, repeats: true) { _ in
                    withAnimation(Animation.easeInOut(duration: flashDuration)) {
                        showFlash = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + flashDuration) {
                        withAnimation {
                            showFlash = false
                        }
                    }
                    currentFlashInterval = Double.random(in: 5...12)
                }
            }
    }
}

struct ThunderstormView: View {
    let isDaytime: Bool
    let cloudiness: Double
    let precipitationType: PrecipitationType
    let precipitationIntensity: Int

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isDaytime
                    ? [Color.blue.opacity(0.5), Color.gray.opacity(0.8)]
                    : [Color.gray.opacity(0.9), Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            PrecipitationView(type: precipitationType, intensity: precipitationIntensity)
                .offset(y: 0)
            
            Lightning()
        }
    }
}

#Preview {
    ThunderView()
}

struct ThunderView: View {
    @State private var showLightning = false
    @State private var boltPath: Path = Path()
    
    var body: some View {
        ZStack {
            if showLightning {
                Color.white.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            ThunderboltShape(path: boltPath)
                .stroke(Color.white, lineWidth: 3)
                .opacity(showLightning ? 1 : 0)
                .blur(radius: 10)
                .animation(.easeOut(duration: 0.5), value: showLightning)
        }
        .onAppear {
            startThunderAnimation()
        }
    }
    
    private func startThunderAnimation() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...5), repeats: true) { _ in
            DispatchQueue.main.async {
                generateThunderboltPath()
                withAnimation {
                    showLightning = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        showLightning = false
                    }
                }
            }
        }
    }
    
    private func generateThunderboltPath() {
            var newPath = Path()
            let screenHeight = UIScreen.main.bounds.height
            let minHeight = screenHeight * 0.5 // Minimum half screen
            let maxHeight = screenHeight * 1.0 // Full screen height
            let boltHeight = CGFloat.random(in: minHeight...maxHeight)
            
            let startX = CGFloat.random(in: UIScreen.main.bounds.width * 0.3...UIScreen.main.bounds.width * 0.7)
            let startY: CGFloat = 0
            var currentPoint = CGPoint(x: startX, y: startY)

            newPath.move(to: currentPoint)
            
            while currentPoint.y < boltHeight {
                let xOffset = CGFloat.random(in: -30...30)
                let yOffset = CGFloat.random(in: 40...60) // Longer segments for larger bolt
                let nextPoint = CGPoint(x: currentPoint.x + xOffset, y: currentPoint.y + yOffset)
                newPath.addLine(to: nextPoint)
                currentPoint = nextPoint
            }
            
            boltPath = newPath
        }
}

struct ThunderboltShape: Shape {
    var path: Path

    func path(in rect: CGRect) -> Path {
        return path
    }
}


