//
//  EventMOdel.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 17/10/25.
//

import Foundation
import WeatherKit

struct Event: Identifiable {
    let id: UUID = UUID()
    let title: String
    let date: Date
    let description: String
}
