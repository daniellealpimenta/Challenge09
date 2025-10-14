//
//  WeatherManager.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherManager {
    static let shared = WeatherManager()
    let service = WeatherService.shared
    
    var temperatureFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }
    
    func fetchWeather(for location: CLLocation) async -> Weather? {
        let weather = await Task.detached(priority: .userInitiated) {
            let forecast = try? await self.service.weather(
                for: location,
            )
            return forecast
        }.value
        return weather
    }
    
    func weatherAttribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attribution
    }
}
