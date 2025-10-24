//
//  RecommendedDays.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 17/10/25.
//

struct RecommendedDays {
    
    static let shared = RecommendedDays()

    func config(for activity: ActivityType) -> (weights: WeatherWeights, prefs: ActivityPreferences) {
        switch activity {
        case .beachDay:
            return (
                WeatherWeights(temp: 0.4, rain: 0.2, uv: 0.3, humidity: 0.1),
                ActivityPreferences(
                    idealTemp: 28...32, maxTemp: 24...36,
                    idealUv: 4...9, maxUv: 0...11,
                    idealRain: 10, maxRain: 30,
                    idealHumidity: 45...65, maxHumidity: 35...75
                )
            )
        case .picnic:
            return (
                WeatherWeights(temp: 0.3, rain: 0.4, uv: 0.2, humidity: 0.1),
                ActivityPreferences(
                    idealTemp: 22...28, maxTemp: 18...32,
                    idealUv: 2...7, maxUv: 0...10,
                    idealRain: 0, maxRain: 30,
                    idealHumidity: 40...65, maxHumidity: 30...75
                )
            )
        case .running:
            return (
                WeatherWeights(temp: 0.3, rain: 0.2, uv: 0.3, humidity: 0.2),
                ActivityPreferences(
                    idealTemp: 16...24, maxTemp: 10...28,
                    idealUv: 0...6, maxUv: 0...8,
                    idealRain: 20, maxRain: 40,
                    idealHumidity: 40...70, maxHumidity: 30...80
                )
            )
        default:
            return (
                WeatherWeights(temp: 0.3, rain: 0.3, uv: 0.2, humidity: 0.2),
                ActivityPreferences(
                    idealTemp: 20...28, maxTemp: 15...32,
                    idealUv: 0...8, maxUv: 0...10,
                    idealRain: 20, maxRain: 50,
                    idealHumidity: 40...70, maxHumidity: 30...80
                )
            )
        }
    }
    
    /// Retorna uma pontuação de 0 a 100 baseada na distância do valor até o intervalo ideal
    func score(for value: Double, ideal: ClosedRange<Double>, allowed: ClosedRange<Double>) -> Double {
        if ideal.contains(value) { return 100 }
        if value < allowed.lowerBound || value > allowed.upperBound { return 0 }

        // distância proporcional ao afastamento do ideal
        let dist = min(abs(value - ideal.lowerBound), abs(value - ideal.upperBound))
        let maxDist = allowed.upperBound - ideal.upperBound
        return max(0, 100 - (dist / maxDist * 100))
    }

    /// Mesmo conceito, mas invertido (quanto MENOR, melhor — ex: chuva)
    func inverseScore(for value: Double, ideal: Double, maxAllowed: Double) -> Double {
        let v = value <= 1 ? value * 100 : value // converte 0–1 para %
        if v <= ideal { return 100 }
        if v >= maxAllowed { return 0 }
        let frac = (v - ideal) / (maxAllowed - ideal)
        return Swift.max(0, 100 * (1 - frac))
    }
    
    func conditionScore(_ condition: String, for activity: ActivityType) -> Double {
        let baseScores: [String: Double] = [
            "clear": 100, "mostlyClear": 90, "partlyCloudy": 85,
            "mostlyCloudy": 70, "cloudy": 60, "foggy": 40,
            "haze": 40, "smoky": 30, "blowingDust": 30
        ]
        let base = baseScores[condition] ?? 50
        
        switch activity {
        case .beachDay, .picnic, .photography:
            return base
        case .running, .cycling, .walkingDog:
            return min(100, base + 10) // nublado não atrapalha
        case .meditation, .camping:
            if ["partlyCloudy", "mostlyClear"].contains(condition) { return 100 }
            return base
        default:
            return base
        }
    }
    
    public func calculateRecommendations(weather: [WeatherModel], activity: Activity) async -> [(recommendation: Int, date: String)] {
        var results: [(recommendation: Int, date: String)] = []
        let (w, p) = config(for: activity.activityType)
        
        for day in weather {
            let tempScore = score(for: day.highestTemperature, ideal: p.idealTemp, allowed: p.maxTemp)
            let uvScore = score(for: Double(day.uvIndex), ideal: p.idealUv, allowed: p.maxUv)
            let rainScore = inverseScore(for: day.precipitationChance, ideal: p.idealRain, maxAllowed: p.maxRain)
            let humidityScore = score(for: day.maximumHumidity, ideal: p.idealHumidity, allowed: p.maxHumidity)
            let condScore = conditionScore(day.condition, for: activity.activityType)
            
            let total = (tempScore * w.temp) +
                        (rainScore * w.rain) +
                        (uvScore * w.uv) +
                        (humidityScore * w.humidity) +
                        (condScore * 0.1)
            
            results.append((recommendation: Int(min(100, total.rounded())), date: day.dateWeather))
        }
        return results
    }

    
    public func generateWeatherResponses(weather: [WeatherModel], recommendationDays: [(recommendation: Int, date: String)],daysCount: Int) async -> [WeatherResponse] {
        
        var weatherResponses: [WeatherResponse] = []
        
        let topDays = recommendationDays.sorted { $0.recommendation > $1.recommendation }.prefix(daysCount)
        
//        for i in topDays {
//            print("Recommendation: \(i.recommendation), Date: \(i.date)")
//        }
        
        for day in weather {
            for i in topDays {
                if day.dateWeather == i.date {
                    let recommendedDay = WeatherResponse.init(date: day.dateWeather, temperature: day.highestTemperature, precipitationChance: day.precipitationChance, humidity: day.maximumHumidity, uvIndex: day.uvIndex,condition: day.condition, symbolWeather: day.symbolWeather ?? "", recommendationDegree: i.recommendation)
                    weatherResponses.append(recommendedDay)
                }
            }
        }
        
        weatherResponses.sort { $0.recommendationDegree > $1.recommendationDegree }
        
        return weatherResponses
        
    }
}

// Pesos dos fatores (temperatura, chuva, UV, umidade)
struct WeatherWeights {
    let temp: Double
    let rain: Double
    let uv: Double
    let humidity: Double
}

// Preferências climáticas por atividade
struct ActivityPreferences {
    let idealTemp: ClosedRange<Double>
    let maxTemp: ClosedRange<Double>
    let idealUv: ClosedRange<Double>
    let maxUv: ClosedRange<Double>
    let idealRain: Double
    let maxRain: Double
    let idealHumidity: ClosedRange<Double>
    let maxHumidity: ClosedRange<Double>
}

