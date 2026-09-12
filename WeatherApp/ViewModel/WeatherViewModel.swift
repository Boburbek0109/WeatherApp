//
//  WeaherViewModel.swift
//  NewProject
//
//  Created by Bobur Sobirjanov on 4/29/26.
//

import Foundation
import Combine
import CoreLocation

enum WeatherLoadState{
    case idle
    case loading
    case loaded
    case failed(String)
}

final class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherData?
    @Published var selectedCityWeather: WeatherData?
    @Published var selectedWeatherPage = 0
    @Published var errorMessage: String?
    @Published var currentLocation: CLLocation?
    @Published var selectedCityLocation: LocationData?
    @Published private(set) var loadState: WeatherLoadState = .idle
    
    private var service: WeatherProviding
    
    init(service: WeatherProviding = WeatherService()) {
        self.service = service
    }
    
    var weatherPages: [WeatherData] {
        [weather, selectedCityWeather].compactMap{ $0 }
    }
    
    func loadWeather(location: CLLocation) async {
        let shouldKeepSelectedCityPage = weather == nil && selectedCityWeather != nil && selectedWeatherPage == 0
        currentLocation = location
        loadState = .loading
        errorMessage = nil
        
        do {
            weather = try await service.fetchWeather(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude)
            if shouldKeepSelectedCityPage {
                selectedWeatherPage = 1
            }
            loadState = .loaded
        } catch {
            let message = error.localizedDescription
            
            errorMessage = message
            loadState = .failed(message)
        }
    }
    
    func addCityWeather(_ location: LocationData) async {
        selectedCityLocation = location
        loadState = .loading
        errorMessage = nil
        
        do {
            let weatherData = try await service.fetchWeather(
                lat: location.latitude,
                lon: location.longitude
            )
            
            selectedCityWeather = weatherData.renamed(to: location.name)
            selectedWeatherPage = weather == nil ? 0 : 1
            loadState = .loaded
            
        } catch {
            let message = error.localizedDescription
            
            errorMessage = message
            loadState = .failed(message)
        }
    }
    
    func retryWeather() async {
        if selectedWeatherPage == 1,
           let selectedCityLocation{
            await addCityWeather(selectedCityLocation)
        } else if let currentLocation {
            await loadWeather(location: currentLocation)
        } else if let selectedCityLocation {
            await addCityWeather(selectedCityLocation)
        }
    }
    
    var selectedWeatherData: WeatherData? {
        guard weatherPages.indices.contains(selectedWeatherPage) else {
            return weather
        }
        
        return weatherPages[selectedWeatherPage]
    }
    
    var selectedDailyForecast: [DayWeather] {
        selectedWeatherData?.dailyForecast ?? []
    }
    
    var selectedHourlyForecast: [TimeModel] {
        selectedWeatherData?.hourlyForecast ?? []
    }
    
    var canOpenWeeklyForecast: Bool {
        !selectedDailyForecast.isEmpty
    }
}
