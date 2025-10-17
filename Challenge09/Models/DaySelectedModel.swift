//
//  DaySelectedModel.swift
//  Challenge09
//
//  Created by Filipi Romão on 17/10/25.
//

import Foundation
import SwiftData

@Model class DaySelectedModel {
    @Attribute(.unique) var id = UUID()
    var nameActivity: String
    var date: Date
    var temperature: Double
    var preciptationChance: Double
    var uvIndex: Int
    
    init(nameActivity: String, date: Date, temperature: Double, preciptationChance: Double, uvIndex: Int) {
        self.nameActivity = nameActivity
        self.date = date
        self.temperature = temperature
        self.preciptationChance = preciptationChance
        self.uvIndex = uvIndex
    }
}
