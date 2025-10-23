//
//  WeatherResponse.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 16/10/25.
//

import Foundation
import FoundationModels

struct WeatherResponse: Codable, Identifiable {
    
    var id = UUID()
    var date: String
    var temperature: Double
    var precipitationChance: Double
    var humidity: Double
    var uvIndex: Int
    var condition: String
    var symbolWeather: String?
    var recommendationDegree: Int
    
    public init(date: String, temperature: Double, precipitationChance: Double, humidity: Double, uvIndex: Int, condition: String, symbolWeather: String, recommendationDegree: Int) {
        self.date = date
        self.temperature = temperature
        self.precipitationChance = precipitationChance
        self.humidity = humidity
        self.uvIndex = uvIndex
        self.condition = condition
        self.symbolWeather = symbolWeather
        self.recommendationDegree = recommendationDegree
    }
}



