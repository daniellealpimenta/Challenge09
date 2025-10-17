//
//  ModelWeather.swift
//  Challenge09
//
//  Created by Filipi Romão on 14/10/25.
//

import Foundation

struct WeatherModel: Codable, Identifiable {
    var id = UUID()
    var symbolWeather: String?
    var dateWeather: String
    var highestTemperature: Double
    var lowestTemperature: Double
    var precipitationChance: Double
    var uvIndex: Int
    var condition: String
    var astromicalDown: Date?
    var astromicalDusk: Date?
    var maximumHumidity: Double
    var minimunHumidity: Double
    
    init(symbolWeather: String? = "cloud.fill",dateWeather:String,highestTemperature: Double, lowestTemperature: Double, precipitationChance: Double, uvIndex: Int, condition: String, astromicalDown: Date? = nil, astromicalDusk: Date? = nil, maximumUmidity: Double, minimunUmidity: Double) {
        self.symbolWeather = symbolWeather
        self.dateWeather = dateWeather
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
        self.precipitationChance = precipitationChance
        self.uvIndex = uvIndex
        self.condition = condition
        self.astromicalDown = astromicalDown
        self.astromicalDusk = astromicalDusk
        self.maximumHumidity = maximumUmidity
        self.minimunHumidity = minimunUmidity
    }
}




