//
//  WeatherSummaryCarousel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 5/5/26.
//

import SwiftUI
import CoreLocation

struct WeatherSummaryCarousel: View{
    
    let weatherPages: [WeatherData]
    let loadState: WeatherLoadState
    let authorizationStatus: CLAuthorizationStatus
    let locationErrorMessage: String?
    let retryAction: () -> Void
    
    @Binding var selectedPage: Int
    
    private var hasLoadError: Bool{
        switch loadState {
        case .failed(_):
            return true
        default:
            return false
        }
    }
    
    private var canSwipe: Bool{
        weatherPages.count > 1
    }
    
    var body: some View{
        VStack(spacing: 8) {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .glassEffect(.clear, in: .rect(cornerRadius: 20))
                
                if weatherPages.isEmpty {
                    WeatherSummary(weatherData: nil,
                                   loadState: loadState,
                                   authorizationStatus: authorizationStatus,
                                   locationErrorMessage: locationErrorMessage,
                                   retryAction: retryAction)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                } else {
                    TabView(selection: $selectedPage) {
                        ForEach(Array(weatherPages.enumerated()), id: \.element.id) { index, weatherData in
                            WeatherSummary(weatherData: weatherData,
                                           loadState: loadState,
                                           authorizationStatus: authorizationStatus,
                                           locationErrorMessage: locationErrorMessage,
                                           retryAction: retryAction)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .blur(radius: hasLoadError ? 5 : 0)
                    .overlay{
                        if hasLoadError{
                            VStack(spacing: 12){
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 42))
                                
                                Text("No internet connected")
                                    .font(.title3)
                                
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
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            
            if canSwipe {
                HStack(spacing: 6) {
                    ForEach(weatherPages.indices, id: \.self) { index in
                        Circle()
                            .fill(.white.opacity(selectedPage == index ? 0.8 : 0.35))
                            .frame(width: selectedPage == index ? 6 : 5,
                                   height: selectedPage == index ? 6 : 5)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WeatherSummaryCarousel(
        weatherPages: [
            WeatherData (locationName: "Seoul",
                         temperature: 24,
                         condiction: "clear",
                         humidity: 72,
                         windSpeed: 4.2,
                         rainVolume: 0,
                         highTemp: 26,
                         lowTemp: 15,
                         hourlyForecast: [],
                         dailyForecast: [],
                         timezoneOffset: 32400)
        ],
        loadState: .loaded,
        authorizationStatus: .authorizedWhenInUse,
        locationErrorMessage: nil,
        retryAction: {},
        selectedPage: .constant(0)
    )
}
