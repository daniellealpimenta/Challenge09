//
//  ModelWeather.swift
//  Challenge09
//
//  Created by Filipi Romão on 14/10/25.
//

import Foundation

struct Weather: Codable, Identifiable {
    var id = UUID()
    var symbolWeather: String?
    var highestTemperature: Double
    var lowestTemperature: Double
    var precipitationChance: Double
    var uvIndex: Int
    var condition: String
    var astromicalDown: Date?
    var astromicalDusk: Date?
    var maximumUmidity: Double
    var minimunUmidity: Double
    
    init(symbolWeather: String? = "cloud.fill" ,highestTemperature: Double, lowestTemperature: Double, precipitationChance: Double, uvIndex: Int, condition: String, astromicalDown: Date? = nil, astromicalDusk: Date? = nil, maximumUmidity: Double, minimunUmidity: Double) {
        self.symbolWeather = symbolWeather
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
        self.precipitationChance = precipitationChance
        self.uvIndex = uvIndex
        self.condition = condition
        self.astromicalDown = astromicalDown
        self.astromicalDusk = astromicalDusk
        self.maximumUmidity = maximumUmidity
        self.minimunUmidity = minimunUmidity
    }
}


let weather1 = Weather(highestTemperature: 20, lowestTemperature: 10, precipitationChance: 0.3, uvIndex: 8, condition: "Sunny", maximumUmidity: 60, minimunUmidity: 40)


