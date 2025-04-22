//
//  FoggyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 20/02/25.
//

import SwiftUI

struct FoggyView: View {
    
    @State var clouds: [Cloud] = Cloud.generateClouds(count: 350)
    
    var body: some View {
        ZStack {
            if !isDayTime {
                dayGradientColor
                    .ignoresSafeArea()
            } else {
                dayGradientColor
                    .ignoresSafeArea()
            }
            
            ForEach(clouds) { cloud in
                Image(systemName: "cloud.fill")
                    .resizable()
                    .frame(width: cloud.size.width, height: cloud.size.height)
                    .position(cloud.position)
                    .foregroundColor(.white.opacity(0.5))
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

#Preview {
    FoggyView()
}
