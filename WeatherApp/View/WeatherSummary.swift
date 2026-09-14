//
//  WeatherSummary.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/5/26.
//

import SwiftUI
import CoreLocation

struct WeatherSummary: View{
    
    let weatherData: WeatherData?
    let loadState: WeatherLoadState
    let authorizationStatus: CLAuthorizationStatus
    let locationErrorMessage: String?
    
    let retryAction: () -> Void
    
    var body: some View{
        
        VStack(alignment: .center, spacing: 8) {
            if let weatherData{
                
                Text(weatherData.condiction)
                    .font(.title2)
                
                Text(weatherData.locationName)
                    .font(.title3)
                
                Image(systemName: weatherData.iconName)
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 82, height: 82)
                
                Text(weatherData.localDateText)
                    .font(.subheadline)
                
                Text(weatherData.temperatureText)
                    .font(.system(size: 54, weight: .semibold))
                    .frame(width: 130)
                
                HStack(spacing: 8) {
                    Text(weatherData.highTempText)
                    Text(weatherData.lowTempText)
                }
                
                switch loadState {
                case .loading:
                    ProgressView()
                        .controlSize(.small)
                    
                case .idle, .loaded, .failed(_):
                    EmptyView()
                }
                
            } else if authorizationStatus == .denied {
                Image(systemName: "location.slash")
                    .font(.system(size: 42))
                
                Text("Location access denied")
                    .font(.title3)
                
                Text("Allow location in Settings or choose a city from the menu")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
            } else if authorizationStatus == .restricted{
                Image(systemName: "location.slash")
                    .font(.system(size: 42))
                
                Text("Location is restricted")
                    .font(.title3)
                
                Text("Location access is restricted on this device. Choose a city from the menu")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            } else if let locationErrorMessage {
                Image(systemName: "location.slash")
                    .font(.system(size: 42))
                
                Text("Unable to determine location")
                    .font(.title3)
                
                Text(locationErrorMessage)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
            } else {
                switch loadState {
                    
                case .idle, .loading:
                    Text("Loading weather...")
                        .font(.title2)
                    
                    ProgressView()
                    
                case .failed(let message):
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 42))
                    
                    Text("Unable to load weather")
                        .font(.title3)
                    
                    Text(message)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    
                    Button{
                        retryAction()
                    } label: {
                        Text("Try Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                    }
                    .glassEffect(.clear, in: Capsule())
                    
                case .loaded:
                    Text("Weather data unavailable")
                }
            }
        }
    }
}

#Preview {
    WeatherSummary(
        weatherData: WeatherData(
            locationName: "Seoul",
            temperature: 24,
            condiction: "clear",
            humidity: 72,
            windSpeed: 4.2,
            rainVolume: 0,
            highTemp: 26,
            lowTemp: 15,
            hourlyForecast: [],
            dailyForecast: [],
            timezoneOffset: 32400),
        loadState: .loaded,
        authorizationStatus: .authorizedWhenInUse,
        locationErrorMessage: nil,
        retryAction: {}
    )
}
