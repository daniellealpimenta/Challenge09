//
//  WeatherConditionTranslate.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 23/10/25.
//

import Foundation

enum TradutorCondicaoClimatica: String {
    
    case blowingDust
    case clear
    case cloudy
    case foggy
    case haze
    case mostlyClear
    case mostlyCloudy
    case partlyCloudy
    case smoky
    
    case breezy
    case windy
    
    case drizzle
    case heavyRain
    case isolatedThunderstorms
    case rain
    case sunShowers
    case scatteredThunderstorms
    case strongStorms
    case thunderstorms
    
    case frigid
    case hail
    case hot
    
    case flurries
    case sleet
    case snow
    case sunFlurries
    case wintryMix
    
    case blizzard
    case blowingSnow
    case freezingDrizzle
    case freezingRain
    case heavySnow
    
    case hurricane
    case tropicalStorm

    var traducao: String {
        switch self {
        case .blowingDust:
            return "Poeira Intensa"
        case .clear:
            return "Céu Limpo"
        case .cloudy:
            return "Nublado"
        case .foggy:
            return "Nevoeiro"
        case .haze:
            return "Névoa Seca"
        case .mostlyClear:
            return "Poucas Nuvens"
        case .mostlyCloudy:
            return "Predominantemente Nublado"
        case .partlyCloudy:
            return "Parcialmente Nublado"
        case .smoky:
            return "Fumaça"
        case .breezy:
            return "Brisa"
        case .windy:
            return "Ventania"
        case .drizzle:
            return "Garoa"
        case .heavyRain:
            return "Chuva Forte"
        case .isolatedThunderstorms:
            return "Trovoadas Isoladas"
        case .rain:
            return "Chuva"
        case .sunShowers:
            return "Chuva com Sol"
        case .scatteredThunderstorms:
            return "Trovoadas Dispersas"
        case .strongStorms:
            return "Tempestades Fortes"
        case .thunderstorms:
            return "Trovoadas"
        case .frigid:
            return "Gélido"
        case .hail:
            return "Granizo"
        case .hot:
            return "Calor Intenso"
        case .flurries:
            return "Flocos de Neve"
        case .sleet:
            return "Aguaneve"
        case .snow:
            return "Neve"
        case .sunFlurries:
            return "Neve com Sol"
        case .wintryMix:
            return "Misto Invernal"
        case .blizzard:
            return "Nevasca"
        case .blowingSnow:
            return "Neve com Vento"
        case .freezingDrizzle:
            return "Garoa Congelante"
        case .freezingRain:
            return "Chuva Congelante"
        case .heavySnow:
            return "Neve Intensa"
        case .hurricane:
            return "Furacão"
        case .tropicalStorm:
            return "Tempestade Tropical"
        }
    }
}
