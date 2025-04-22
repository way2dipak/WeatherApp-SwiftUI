//
//  SnowyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 14/02/25.
//

import SwiftUI

struct SnowyView: View {
    var snowFlakes: [SnowFlakesModel] = SnowFlakesModel.generateSnow(intensity: 250)
    var isCloudiness: Bool
    var clouds: [Cloud] = Cloud.generateClouds(count: 250)

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            if isCloudiness {
                HazyView(clouds: isDayTime ? clouds : [])
            }
            
            ForEach(snowFlakes) { flakes in
                SnowFlakesView(snowFlakes: flakes)
            }
        }
        .onAppear {

        }
    }
}

struct SnowFlakesModel: Identifiable {
    let id: UUID
    var xPosition: CGFloat
    var yPosition: CGFloat
    var size: CGFloat
    var speed: Double
    var opacity: Double
    
    static func generateSnow(intensity: Int) -> [SnowFlakesModel] {
        var drops: [SnowFlakesModel] = []
        
        for _ in 0..<intensity {
            let drop = SnowFlakesModel(
                id: UUID(),
                xPosition: CGFloat.random(in: 50...UIScreen.main.bounds.width + 50),
                yPosition: CGFloat.random(in: -100...UIScreen.main.bounds.height / 2),
                size: CGFloat.random(in: 1...10),
                speed: Double.random(in: 2...10),
                opacity: Double.random(in: 0.1...0.6)
            )
            drops.append(drop)
        }
        
        return drops
    }
}

struct SnowFlakesView: View {
    var snowFlakes: SnowFlakesModel
    @State private var position: CGPoint
    
    init(snowFlakes: SnowFlakesModel) {
        self.snowFlakes = snowFlakes
        _position = State(initialValue: CGPoint(x: snowFlakes.xPosition, y: snowFlakes.yPosition))
    }
    
    var body: some View {
        //Image(systemName: "line.diagonal")
        Image(systemName: "snowflake")
            .resizable()
            .scaledToFit()
            .frame(width: snowFlakes.size, height: snowFlakes.size)
            .rotationEffect(.degrees(-30))
            .foregroundColor(.white.opacity(snowFlakes.opacity))
            .position(position)
            .onAppear {
                withAnimation(Animation.linear(duration: snowFlakes.speed).repeatForever(autoreverses: false)) {
                    position.x -= UIScreen.main.bounds.width / 1 // Moves diagonally right
                    position.y += UIScreen.main.bounds.height // Moves downward
                }
            }
    }
}

struct snowFlakesView_Previews: PreviewProvider {
    static var previews: some View {
        SnowyView(isCloudiness: true)
    }
}
