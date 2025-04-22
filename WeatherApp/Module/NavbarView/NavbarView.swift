//
//  NavbarView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 02/10/23.
//

import SwiftUI

struct NavbarView: View {
    @Binding var isCityNameRequired: Bool
    @EnvironmentObject var router: Router
    
    let cityName: String
    let currentPage: Int
    let totalPage: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 40) {
                if isCityNameRequired {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        CityNameView(currentPage: currentPage,
                                     totalPages: totalPage,
                                     cityName: cityName)
                            .padding(.leading, 9)
                    }
                    Spacer()
                }
//                Button {
//                    router.push(.search)
//                } label: {
//                        Image(systemName: "plus")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundColor(.white)
//                            .frame(width: 20, height: 20)
//                        
//                }
                Button {
                    router.push(.settings)
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                }
            }
            .hSpacing(.trailing)
            .padding(.horizontal, 20)
            .frame(height: 50)
        }
        
    }
}

struct NavbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavbarView(isCityNameRequired: .constant(false),
                   cityName: "Bengaluru",
                   currentPage: 0,
                   totalPage: 3)
                .background(Color.black)
    }
}
