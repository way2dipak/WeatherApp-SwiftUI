//
//  NightSkyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/02/25.
//

import SwiftUI
import Combine

class StarFieldAnimator: ObservableObject {
    @Published private(set) var stars: [StarModel] = []
    
    class StarModel: Identifiable {
        var position: CGPoint
        var size: CGFloat
        var brightness: Double
        let id = UUID().uuidString
        
        internal init(position: CGPoint, size: CGFloat, brightness: Double) {
            self.position = position
            self.size = size
            self.brightness = brightness
        }
    }
    
    init(starCount: Int) {
        for _ in 0..<starCount {
            let star = StarModel(
                position: .init(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1)),
                size: CGFloat.random(in: 1...3),
                brightness: Double.random(in: 0.5...1.0)
            )
            stars.append(star)
        }
    }
}

private struct Star: Shape {
    var origin: CGPoint
    var size: CGFloat
    var brightness: Double
    
    func path(in rect: CGRect) -> Path {
        let adjustedX = rect.width * origin.x
        let adjustedY = rect.height * origin.y
        let starRect = CGRect(x: adjustedX - size / 2, y: adjustedY - size / 2, width: size, height: size)
        return Path(ellipseIn: starRect)
    }
}

private struct Sun: View {
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.yellow.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .center,
                        endPoint: .bottom
                    ),
                    lineWidth: 50
                )
                .frame(width: 300, height: 300)
                .blur(radius: 50)
            
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.8), Color.yellow.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 150, height: 150)
                .blur(radius: 30)
                .scaleEffect(pulse ? 1.1 : 1.0)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }
        }
    }
}

// DaySkyView
private struct DaySkyView: View {
    var cloudiness: CloudType
    var body: some View {
        ZStack {
            dayGradientColor
                .ignoresSafeArea()
            
            Sun()
                .offset(x: 0, y: -250)
            FloatingCloudsView(cloudiness: cloudiness)
                .blur(radius: 10)
        }
    }
}

private struct NightSkyView: View {
    @StateObject private var starFieldAnimator = StarFieldAnimator(starCount: 20)
    var cloudiness: CloudType
    
    var body: some View {
        ZStack {
            nightGradientColor
                .ignoresSafeArea()
            
            ForEach(starFieldAnimator.stars) { star in
                let blurAmount = min(1, 1 * star.position.y)
                Star(origin: star.position, size: star.size, brightness: star.brightness)
                    .fill(Color.white.opacity(star.brightness))
                    .blur(radius: blurAmount)
            }
            
            FloatingCloudsView(cloudiness: cloudiness)
            
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.clear, location: 0.0),
                    .init(color: Color.black.opacity(0.3), location: 0.7),
                    .init(color: Color.black.opacity(0.7), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.plusLighter)
            .ignoresSafeArea()
        }
    }
}

struct SkyView: View {
    var day: Bool
    var cloudiness: CloudType
    
    var body: some View {
        if day {
            DaySkyView(cloudiness: cloudiness)
        } else {
            NightSkyView(cloudiness: cloudiness)
        }
    }
}

struct FloatingCloudsView: View {
    @State private var clouds: [CloudModel] = []
    var cloudiness: CloudType
    
    var body: some View {
        ZStack {
            // Floating Clouds
            ForEach(clouds) { cloud in
                CloudView(size: cloud.size, opacity: cloud.opacity)
                    .position(cloud.position)
                    .onAppear {
                        animateCloud(cloudIndex: cloud.id)
                    }
            }
        }
        .onAppear {
            generateClouds(for: cloudiness)
        }
    }
    
    private func generateClouds(for condition: CloudType) {
        let cloudCount: Int
        let opacityRange: ClosedRange<Double>
        let sizeRange: ClosedRange<CGFloat>
        
        switch condition {
        case .clear:
            cloudCount = 0  // No clouds
            opacityRange = 0.3...0.5
            sizeRange = 80...120
        case .few:
            cloudCount = 3
            opacityRange = 0.3...0.6
            sizeRange = 100...150
        case .scattered:
            cloudCount = 15
            opacityRange = 0.3...0.7
            sizeRange = 120...270
        case .broken:
            cloudCount = 10
            opacityRange = 0.5...0.8
            sizeRange = 130...180
        case .overcast:
            cloudCount = 50
            opacityRange = 0.6...0.9
            sizeRange = 140...200
        }
        clouds = (0..<cloudCount).map { index in
            CloudModel(
                id: index,
                position: CGPoint(x: CGFloat.random(in: 10...kDeviceSize.height/2),
                                  y: CGFloat.random(in: 50...kDeviceSize.height/2)),
                size: CGFloat.random(in: sizeRange),
                opacity: Double.random(in: opacityRange),
                speed: Double.random(in: 50...80) // Different speed for each cloud
            )
        }
    }
    
    // Animate cloud movement
    private func animateCloud(cloudIndex: Int) {
        guard let screenWidth = UIScreen.main.bounds.width as CGFloat? else { return }
        let targetX = screenWidth + 10
        let moveDuration = clouds[cloudIndex].speed
        
        DispatchQueue.main.async {
            withAnimation(.linear(duration: moveDuration)) {
                clouds[cloudIndex].position.x = targetX
            }
        }
        
        // Reset and restart animation when cloud moves out of screen
        DispatchQueue.main.asyncAfter(deadline: .now() + moveDuration) {
            clouds[cloudIndex].position.x = -clouds[cloudIndex].size
            animateCloud(cloudIndex: cloudIndex) // Restart movement
        }
    }
}

// MARK: - Cloud Data Model
struct CloudModel: Identifiable {
    let id: Int
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let speed: Double
}

// MARK: - Cloud Shape View
struct CloudView: View {
    var size: CGFloat
    var opacity: Double
    
    var body: some View {
        //Image(systemName: "cloud.fill") // Use SF Symbols cloud icon
        Image("cloud")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size * 0.6)
        .foregroundColor(Color.white.opacity(opacity))
//            .foregroundStyle(
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color.white,
//                        //Color.black,
//                        Color(hex: "#0D0D33"),
//                    ]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//            )
            .opacity(opacity)
            .blur(radius: 10)
    }
}



#Preview {
    SkyView(day: true, cloudiness: .clear)
    //FloatingCloudsView(cloudiness: .broken)
    //DaySkyView(cloudiness: .broken)
    //Sun()
        .preferredColorScheme(.dark)
}
