//
//  weatherDataModelMock.swift
//  Challenge09
//
//  Created by Filipi Romão on 17/10/25.
//

import Foundation

struct WeatherDataModelMock: Codable, Identifiable {
    
    var id = UUID()
    var date: String
    var temperature: Double
    var precipitationChance: Double
    var humidity: Double
    var uvIndex: Int
    var recomendationDegree: Int
    
    public init(date: String, temperature: Double, precipitationChance: Double, humidity: Double, uvIndex: Int, recomendationDegree: Int) {
        self.date = date
        self.temperature = temperature
        self.precipitationChance = precipitationChance
        self.humidity = humidity
        self.uvIndex = uvIndex
        self.recomendationDegree = recomendationDegree
    }
}
