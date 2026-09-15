# Weather App

A SwiftUI weather application that shows current weather, hourly forecast, and forecast details for the user's current location and selected cities.

## Demo

https://github.com/user-attachments/assets/3129c5ea-70c0-4223-8968-ce98023b3d87

## Overview

WeatherApp was built to practice the complete flow of a modern iOS application: requesting location permission, loading data from a remote API, decoding JSON, managing UI state, persisting a user's selection, and testing asynchronous ViewModel logic.

The app uses the OpenWeather Current Weather and free 5 Day / 3 Hour Forecast APIs.

## About the Project

This project was built as a learning project to practice real iOS app development with SwiftUI, MVVM architecture, networking, JSON decoding, CoreLocation, and local persistence with SwiftData.
The main goal was not only to build a weather UI, but also to understand how different parts of an iOS application work together:

- requesting the user's current location
- fetching real weather data from an API
- decoding JSON responses into Swift models
- separating UI, business logic, and networking
- saving the selected city locally
- building reusable SwiftUI components

## Features

- Current weather based on the user's location
- Manual city selection when location access is unavailable
- Temperature, humidity, wind speed, and rain information
- Short-term timeline based on OpenWeather's 3-hour forecast data
- Multi-day forecast aggregated from the 5-day response
- Swipeable carousel for current and selected locations
- Selected-city persistence with SwiftData
- Loading, network error, and location-permission states
- Retry support after failed requests
- City-specific date and time formatting
- SwiftUI glass-style interface

## Testing

The project uses Swift Testing with protocol-based dependency injection.

The tests cover:

- initial ViewModel state
- successful and failed weather loading
- selected-city loading and renaming
- preserving existing data after failure
- retrying the current-location request

## Tech Stack

- Swift and SwiftUI
- MVVM
- Swift Concurrency (`async/await`, `async let`)
- URLSession
- CoreLocation
- SwiftData
- Swift Testing
- JSONDecoder
- OpenWeather API

## Setup

1. Get a free API key from OpenWeather.
2. Create `WeatherApp/Models/Secrets/Secrets.swift`.
3. Add:
```swift
enum Secrets {
    static let openWeatherApiKey = "YOUR_API_KEY"
}
```
4. Build and run the project in Xcode.

## Requirements

- Xcode 26 or later
- iOS 26.0 or later
- Free OpenWeather API key

## API Limitation

OpenWeather's free forecast endpoint provides data in 3-hour intervals for 5 days. The displayed short-term timeline and daily summaries are built from this available data.

## Helpful resource: 

- https://medium.com/better-programming/simple-weather-app-with-swiftui-ac41200a9d4d
- https://www.youtube.com/@seanallen
- bigmountainstudio.com
- AI
