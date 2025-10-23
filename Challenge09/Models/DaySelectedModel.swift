//
//  DaySelectedModel.swift
//  Challenge09
//
//  Created by Filipi Romão on 17/10/25.
//

import Foundation
import SwiftData

@Model
class DaySelectedModel {
    var id = UUID()
    var nameActivity: String
    var date: String
    var temperature: Double
    var precipitationChance: Double
    var humidity: Double
    var uvIndex: Int
    var condition: String
    var symbolWeather: String?
    var recommendationDegree: Int
    
    init(
        nameActivity: String,
        date: String,
        temperature: Double,
        precipitationChance: Double,
        humidity: Double,
        uvIndex: Int,
        condition: String,
        symbolWeather: String,
        recommendationDegree: Int
    ) {
        self.nameActivity = nameActivity
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
