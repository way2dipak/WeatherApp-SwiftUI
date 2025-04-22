# 🌦️ WeatherApp - SwiftUI

A beautifully designed weather app built using **SwiftUI** that fetches real-time weather data from the [AccuWeather API](https://developer.accuweather.com/). This app demonstrates the use of SwiftUI components, MVVM architecture, and API integration.

---

## 🚀 Features

- 🌤️ Current weather based on user location
- 🔁 Pull-to-refresh to update weather info
- 🕒 Hourly forecast
- 📆 5-day weather forecast
- 📍 Location-based city name display
- 🧭 Animated weather backgrounds (day/night/rain/thunder/snow effects)
- 🧼 Clean MVVM architecture

---

## 🧱 Tech Stack

| Tool | Description |
|------|-------------|
| SwiftUI | Declarative UI framework |
| Combine | Data binding and reactive programming |
| AccuWeather API | Weather data provider |
| CoreLocation | To get user location |
| MVVM | Architectural pattern |

---

## 📸 Screenshots

![WeatherApp](https://github.com/user-attachments/assets/9ae682db-054f-41ae-aa7e-5311b336d4d2)

---

## 🔧 Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/way2dipak/WeatherApp-SwiftUI.git
cd WeatherApp-SwiftUI
```

### 2. Open in Xcode
Double-click the `WeatherApp.xcodeproj` or open via terminal:

```bash
open WeatherApp.xcodeproj
```

### 3. Install Dependencies
No external package dependencies required — everything is native SwiftUI.

### 4. Get AccuWeather API Key
- Sign up on [AccuWeather Developer Portal](https://developer.accuweather.com/)
- Generate an API key
- Add the key to Constant.swift

```swift
var apiKey = "YOUR_ACCUWEATHER_API_KEY"
```

### 5. Run the App
Select a simulator or connect your iOS device and run the project using the ▶️ button in Xcode.

---

## 📁 Project Structure

```
WeatherApp/
├── Views/               # SwiftUI views
├── ViewModels/          # ObservableObjects
├── Models/              # Codable structs for weather data
├── Services/            # Network and Location services
├── Utilities/           # Helper extensions and constants
├── Assets/              # Icons, background images, etc.
└── WeatherAppApp.swift  # App entry point
```

---

## 🧪 Future Enhancements

- 📍 Search based Multi-city support
- 🔔 Weather alerts with notifications
- 📊 Charts for temperature trends
- 🌐 Localization support
- 🌐 Light and dark mode support
- 🌙 Dynamic UI based on time of day

---

## 🛡️ License

This project is licensed under the MIT License.

---

## 🙋‍♂️ Author

👤 **Dipak Singh**  
🔗 [GitHub](https://github.com/way2dipak)  
📧 developer.dipak@gmail.com

---

## 🙌 Acknowledgments

- [AccuWeather](https://www.accuweather.com/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
