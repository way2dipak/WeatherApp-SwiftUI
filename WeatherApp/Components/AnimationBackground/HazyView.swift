//
//  HazyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 14/02/25.
//

import SwiftUI

struct HazyView: View {
    
    @State var clouds: [Cloud] = []
    
    var body: some View {
        ZStack {
            if isDayTime {
                Color.gray.opacity(0.6)
                    .ignoresSafeArea()
            } else {
                nightGradientColor
                    .ignoresSafeArea()
            }
            
            ForEach(clouds) { cloud in
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: cloud.size.width, height: cloud.size.height)
                    .position(cloud.position)
                    .foregroundColor(.gray)
                    .position(cloud.position)
                    .blur(radius: CGFloat.random(in: 40...80))
            }
        }
        .onAppear {
            animateClouds()
        }
    }
    
    func animateClouds() {
        for i in clouds.indices {
            let randomXOffset = CGFloat.random(in: 50...kDeviceSize.width - 100)
            let randomYOffset = CGFloat.random(in: 20...kDeviceSize.height - 100)
            let newPosition = CGPoint(
                x: clouds[i].position.x + randomXOffset,
                y: clouds[i].position.y + randomYOffset
            )
            
            withAnimation {
                clouds[i].position = newPosition
            }
        }
    }
}

struct Cloud: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGSize
    var animationDuration: Double

    static func generateClouds(count: Int,
                               in bounds: CGRect = UIScreen.main.bounds) -> [Cloud] {
        (0..<count).map { _ in
            Cloud(
                position: CGPoint(
                    x: CGFloat.random(in: bounds.minX + 50...bounds.maxX - 50),
                    y: CGFloat.random(in: bounds.minY + 50...bounds.maxY / 2)
                ),
                size: CGSize(
                    width: CGFloat.random(in: 60...250),
                    height: CGFloat.random(in: 40...200)
                ),
                animationDuration: Double.random(in: 0.1...3)
            )
        }
    }
}
