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

// 1) Mais quente - uv index (Preferencialmente baixo, mas ne)⬇️ - chuva ⬇️ - humidade ↕️ - temperatura ⬆️
// 2) Mais ameno - uv index ⬇️ - chuva ↕️ - humidade ↕️ - temperatura ↕️
// 3) Mais frio - uv index ⬇️ - chuva ⬆️ - humidade ⬆️ - temperatura ⬇️
//

enum ActivityType: String, CaseIterable, Codable, Hashable {
    case walkingDog = "Passear com o cachorro" // 2
    case running = "Corrida" // 3
    case picnic = "Piquenique" // 2
    case hiking = "Trilha" // 2
    case cycling = "Ciclismo" // 2
    case beachDay = "Dia de praia" // 1
    case photography = "Fotografia" // 2
    case meditation = "Meditação ao ar livre" // 2
    case camping = "Acampamento" // 2
    case playingSports = "Jogar esportes" // 2
}
