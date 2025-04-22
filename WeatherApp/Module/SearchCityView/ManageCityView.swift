//
//  ManageCityView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 03/10/23.
//

import SwiftUI

struct ManageCityView: View {
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vwModel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                LazyVStack {
                    ForEach(vwModel.homeData, id: \.key) { details in
                        CityWeatherView(details: details.currentWeatherDetails,
                                        location: details.geoPosition,
                                        isDefaultLocation: details.isDefaultLocation())
                        .padding(.horizontal, 16)
                    }
                }
            }
            .onAppear {
                vwModel.fetchCityList()
            }
            .navigationBarTitle("Manage cities")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                    }
                    
                }
            }
        }
        .searchable(text: $searchText, prompt: "Enter Location")
        .foregroundColor(.red)
        .background(Color.red)
    }
}

struct ManageCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageCityView()
            .environmentObject(Router())
        .preferredColorScheme(.dark)
    }
}
