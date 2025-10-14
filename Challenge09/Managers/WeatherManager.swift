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
    var weatherDays: [WeatherModel] = []
    
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
        if let weatherExists = weather {
            for weatherDay in weatherExists.dailyForecast {
                let weatherDayInit = WeatherModel(symbolWeather: weatherDay.symbolName, dateWeather: weatherDay.date.formatted(date: .abbreviated, time: .omitted), highestTemperature: weatherDay.highTemperature.value, lowestTemperature: weatherDay.lowTemperature.value, precipitationChance: weatherDay.precipitationChance, uvIndex: weatherDay.uvIndex.value, condition: weatherDay.condition.rawValue, maximumUmidity: weatherDay.maximumHumidity, minimunUmidity: weatherDay.minimumHumidity)
                
                weatherDays.append(weatherDayInit)
            }
        }
        
        return weather
    }
    
    func weatherAttribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attribution
    }
}
