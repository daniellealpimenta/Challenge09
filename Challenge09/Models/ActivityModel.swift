//
//  ActivityModel.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 16/10/25.
//

import Foundation

struct Activity: Identifiable {
    let id: UUID = UUID()
    var name: String
    var maxDays: Int
    var activityType: ActivityType
    
}

enum ActivityType: String, CaseIterable, Codable, Hashable {
    case walkingDog = "Passear com o cachorro"
    case running = "Corrida"
    case picnic = "Piquenique"
    case hiking = "Trilha"
    case cycling = "Ciclismo"
    case beachDay = "Dia de praia"
    case photography = "Fotografia"
    case meditation = "Meditação ao ar livre"
    case camping = "Acampamento"
    case playingSports = "Jogar esportes"
}
