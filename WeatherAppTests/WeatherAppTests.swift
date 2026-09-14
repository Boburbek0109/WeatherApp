//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Bobur Sobirjanov on 9/12/26.
//

import Testing
import CoreLocation
@testable import WeatherApp

@MainActor
struct WeatherAppTests {

    @Test("Initial state is empty")
    func initialState() {
        let vm = WeatherViewModel()
        
        #expect(vm.weather ==  nil)
        #expect(vm.canOpenWeeklyForecast == false)
        #expect(vm.errorMessage == nil)
        #expect(vm.selectedCityWeather == nil)
        #expect(vm.selectedWeatherPage == 0)
        
    }
    
    @Test("Successful load saves weather")
    func loadWeatherSuccessfully() async {
        let expectedWeather = WeatherData(
            locationName: "Current Location",
            temperature: 20,
            condiction: "Clear",
            humidity: 40,
            windSpeed: 3,
            rainVolume: 0,
            highTemp: 15,
            lowTemp: 0,
            hourlyForecast: [],
            dailyForecast: [],
            timezoneOffset: 0
        )
        let service = MockWeatherService(weather: expectedWeather)
        let vm = WeatherViewModel(service: service)
        let testLocation = CLLocation(latitude: 37.1595, longitude: 126.8526)
        
        await vm.loadWeather(location: testLocation)
        
        #expect(vm.weather?.temperature == 20)
        #expect(vm.currentLocation == testLocation)
        
        if case .loaded = vm.loadState {
            
        } else{
            Issue.record("Expected the loaded state")
        }
    }
    
    @Test("Weather load failure sets error state")
    func loadWeatherFailure() async {
        let service = FailingWeatherService()
        let vm = WeatherViewModel(service: service)
        let testLocation = CLLocation( latitude: 37.1595, longitude: 126.8526 )
        
        await vm.loadWeather(location: testLocation)
        
        #expect(vm.errorMessage != nil)
        if case .failed = vm.loadState {
            
        } else {
            Issue.record("Expected the failed state")
        }
    }
    
    @Test("Successful city load renames selected weather")
    func addCityWeatherSuccessfully() async {
        let expectedWeather = WeatherData(
            locationName: "Current Location",
            temperature: 20,
            condiction: "Clear",
            humidity: 40,
            windSpeed: 3,
            rainVolume: 0,
            highTemp: 15,
            lowTemp: 0,
            hourlyForecast: [],
            dailyForecast: [],
            timezoneOffset: 0
        )
        let service = MockWeatherService(weather: expectedWeather)
        let vm = WeatherViewModel(service: service)
        let testCity = LocationData(name: "Toshkent", latitude: 41.3111, longitude: 69.2797)
        
        await vm.addCityWeather(testCity)
        
        #expect(vm.selectedCityWeather?.locationName == testCity.name)
        #expect(vm.errorMessage == nil)
        
        if case .loaded = vm.loadState {
            
        } else{
            Issue.record("Expected the loaded state")
        }
    }
    
    @Test("Failed city load preserves existing weather")
    func addCityWeatherFailure() async {
        let expectedWeather = WeatherData(
            locationName: "Seoul",
            temperature: 20,
            condiction: "Clear",
            humidity: 40,
            windSpeed: 3,
            rainVolume: 0,
            highTemp: 15,
            lowTemp: 0,
            hourlyForecast: [],
            dailyForecast: [],
            timezoneOffset: 0
        )
        let service = FailingWeatherService()
        let vm = WeatherViewModel(service: service)
        let testCity = LocationData(name: "Toshkent", latitude: 41.3111, longitude: 69.2797)
        
        vm.selectedCityWeather = expectedWeather
        await vm.addCityWeather(testCity)
        
        #expect(vm.selectedCityWeather?.locationName == expectedWeather.locationName)
        #expect(vm.errorMessage != nil)
        
        if case .failed = vm.loadState {
            
        } else{
            Issue.record("Expected the failed state")
        }
    }

    @Test("Retry loads weather for current location")
    func retryLoadsCurrentLocation() async {
        let expectedWeather = WeatherData(
            locationName: "Current Location",
            temperature: 20,
            condiction: "Clear",
            humidity: 40,
            windSpeed: 3,
            rainVolume: 0,
            highTemp: 15,
            lowTemp: 0,
            hourlyForecast: [],
            dailyForecast: [],
            timezoneOffset: 0
        )
        let service = MockWeatherService(weather: expectedWeather)
        let vm = WeatherViewModel(service: service)
        
        vm.currentLocation = CLLocation(
            latitude: 37.1595, longitude: 126.8526
        )
        
        vm.selectedWeatherPage = 0
        
        await vm.retryWeather()
        
        #expect(vm.weather?.locationName == "Current Location")
        #expect(vm.selectedCityWeather == nil)
        #expect(vm.errorMessage == nil)
        
    }
}


private struct MockWeatherService: WeatherProviding{
    let weather: WeatherData
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        weather
    }
}

private struct FailingWeatherService: WeatherProviding{
    
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        throw URLError(.notConnectedToInternet)
    }
}
