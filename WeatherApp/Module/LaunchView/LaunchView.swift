//
//  LaunchView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/10/23.
//

import SwiftUI

struct LaunchView: View {
    @State private var isActive: Bool = false
    @State private var isLoading = true
    @StateObject private var vwModel = LaunchViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Image("splash")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: kDeviceSize.width,
                       height: kDeviceSize.height,
                       alignment: .center)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .opacity(isLoading ? 1 : 0)
                
            }
            .padding(.bottom, 50)
        }
        .onReceive(vwModel.$locationReceived) { status in
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    router.push(.home)
                })
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .preferredColorScheme(.dark)
            .environmentObject(Router())
    }
}


