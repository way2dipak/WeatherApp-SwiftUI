//
//  RainyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 14/02/25.
//

import SwiftUI

struct RainyView: View {
    var raindrops: [Raindrop] = Raindrop.generateRain(intensity: 250)
    var isThunder: Bool
    
    var isCloudiness: Bool
    var clouds: [Cloud] = Cloud.generateClouds(count: 250)

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            if isCloudiness {
                HazyView(clouds: clouds)
            }
            if isThunder {
                ThunderView()
            }
            
            ForEach(raindrops) { drop in
                RainDropView(raindrop: drop)
            }
        }
        .onAppear {

        }
    }
}

struct Raindrop: Identifiable {
    let id: UUID
    var xPosition: CGFloat
    var yPosition: CGFloat
    var size: CGFloat
    var speed: Double
    var opacity: Double
    
    static func generateRain(intensity: Int) -> [Raindrop] {
        var drops: [Raindrop] = []
        
        for _ in 0..<intensity {
            let drop = Raindrop(
                id: UUID(),
                xPosition: CGFloat.random(in: 50...UIScreen.main.bounds.width + 50),
                yPosition: CGFloat.random(in: -100...UIScreen.main.bounds.height / 2),
                size: CGFloat.random(in: 1...15),
                speed: Double.random(in: 2...3),
                opacity: Double.random(in: 0.3...0.6)
            )
            drops.append(drop)
        }
        
        return drops
    }
}

struct RainDropView: View {
    var raindrop: Raindrop
    @State private var position: CGPoint
    
    init(raindrop: Raindrop) {
        self.raindrop = raindrop
        _position = State(initialValue: CGPoint(x: raindrop.xPosition, y: raindrop.yPosition))
    }
    
    var body: some View {
        Image(systemName: "line.diagonal")
            .resizable()
            .scaledToFit()
            .frame(width: raindrop.size, height: raindrop.size)
            .rotationEffect(.degrees(-30))
            .foregroundColor(.white.opacity(raindrop.opacity))
            .position(position)
            .onAppear {
                withAnimation(Animation.linear(duration: raindrop.speed).repeatForever(autoreverses: false)) {
                    position.x -= UIScreen.main.bounds.width / 1 // Moves diagonally right
                    position.y += UIScreen.main.bounds.height // Moves downward
                }
            }
    }
}

struct RainView_Previews: PreviewProvider {
    static var previews: some View {
        RainyView(isThunder: true, isCloudiness: true)
    }
}
