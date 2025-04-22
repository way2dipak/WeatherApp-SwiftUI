//
//  PrivacyPolicyView.swift
//  WeatherApp
//
//  Created by Dipak Singh on 09/02/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    policySection(title: "Effective Date:", content: "February 16, 2025")
                    
                    Text("At Weather App, We want to assure that We provide You, as a User, with information and choice about Our policies and practices. We do this so You may make informed decisions whether or not You want to use Weather App Sites and how you choose to use them.")
                        .scaledFont(weight: .regular, size: 16)
                    
                    sectionTitle("1. Information We Collect")
                    policyText("We may collect personal and non-personal data, including location data (if permission is granted), app usage statistics, and preferences such as temperature units.")

                    sectionTitle("2. How We Use Your Information")
                    policyText("""
                    - Provide accurate weather forecasts
                    - Improve app performance
                    - Customize user experience
                    - Ensure legal compliance
                    """)

                    sectionTitle("3. Location Data")
                    policyText("If you allow location access, we use it to provide local weather updates. You can disable it in your device settings.")

                    sectionTitle("4. Third-Party Services")
                    policyText("""
                    - Weather Data: AccuWeather, OpenWeather, WAQI
                    - Analytics: Google Firebase
                    - User Preferences: Apple’s AppStorage & UserDefaults
                    """)

                    sectionTitle("5. Data Retention & Security")
                    policyText("Your preferences remain unless you uninstall the app or reset them. We implement security measures but cannot guarantee absolute security.")

                    sectionTitle("6. Your Rights & Choices")
                    policyText("""
                    - **Access & Update:** Modify preferences in app settings.
                    - **Delete Data:** Uninstalling removes stored data.
                    - **Withdraw Consent:** Disable location services in settings.
                    """)

                    sectionTitle("7. Changes to This Policy")
                    policyText("We may update this Privacy Policy occasionally. The latest version will always be available in the app settings.")

                    sectionTitle("8. Contact Us")
                    policyText("""
                    📧 Email: way2developer.dipak@gmail.com
                    🌍 Website: www.github.com/way2dipak
                    """)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    private func policySection(title: String, content: String) -> some View {
        HStack {
            Text(title)
                .scaledFont(weight: .medium, size: 16)
                .foregroundColor(.black)
            Text(content)
                .scaledFont(weight: .regular, size: 16)
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .scaledFont(weight: .medium, size: 16)
            .foregroundColor(.black)
            .padding(.top, 10)
    }

    private func policyText(_ text: String) -> some View {
        Text(text)
            .scaledFont(weight: .regular, size: 16)
            .foregroundColor(.black)
    }
}

#Preview {
    PrivacyPolicyView()
}
