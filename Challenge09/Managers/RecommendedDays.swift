//
//  RecommendedDays.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 17/10/25.
//

struct RecommendedDays {
    
    static let shared = RecommendedDays()
    
    public func calculateRecommendations(weather: [WeatherModel]) async -> [(recommendation: Int,date: String)] {
        
        var recommendationDays: [(recommendation: Int, date: String)] = []
        
        for day in weather {
            // 1️⃣ Temperatura (ideal 22–28°C)
            let tempScore: Double
            if day.highestTemperature < 18 || day.highestTemperature > 32 {
                tempScore = 0
            } else if day.highestTemperature < 22 {
                tempScore = (day.highestTemperature - 18) / 4 * 100
            } else if day.highestTemperature <= 28 {
                tempScore = 100
            } else {
                tempScore = max(0, (32 - day.highestTemperature) / 4 * 100)
            }

            // 2️⃣ Chance de chuva (0–20% é ótimo)
            let rainScore: Double
            if day.precipitationChance <= 20 {
                rainScore = 100
            } else if day.precipitationChance <= 50 {
                rainScore = 100 - ((day.precipitationChance - 20) / 30 * 50)
            } else {
                rainScore = max(0, 50 - ((day.precipitationChance - 50) / 50 * 50))
            }

            // 3️⃣ UV Index (0–7 é bom, >10 é ruim)
            let uvScore: Double
            if day.uvIndex <= 7 {
                uvScore = 100
            } else if day.uvIndex <= 10 {
                uvScore = 100 - Double((day.uvIndex - 7) * 20)
            } else {
                uvScore = 0
            }

            // 4️⃣ Umidade máxima (40–65% ideal)
            let humidityScore: Double
            if day.maximumHumidity < 40 {
                humidityScore = (day.maximumHumidity / 40) * 100
            } else if day.maximumHumidity <= 65 {
                humidityScore = 100
            } else if day.maximumHumidity <= 80 {
                humidityScore = 100 - ((day.maximumHumidity - 65) / 15 * 50)
            } else {
                humidityScore = 0
            }

            // 5️⃣ Cálculo ponderado final
            let finalScore = Int(
                (tempScore * 0.4) +
                (rainScore * 0.3) +
                (uvScore * 0.2) +
                (humidityScore * 0.1)
            )
            
            recommendationDays.append((recommendation: finalScore, date: day.dateWeather))
            
        }
        
        return recommendationDays
    }
    
    public func generateWeatherResponses(weather: [WeatherModel], recommendationDays: [(recommendation: Int, date: String)]) async -> [WeatherResponse] {
        
        var weatherResponses: [WeatherResponse] = []
        
        let topDays = recommendationDays.sorted { $0.recommendation > $1.recommendation }.prefix(3)
        
        for i in topDays {
            print("Recommendation: \(i.recommendation), Date: \(i.date)")
        }
        
        for day in weather {
            for i in topDays {
                if day.dateWeather == i.date {
                    let recommendedDay = WeatherResponse.init(date: day.dateWeather, temperature: day.highestTemperature, precipitationChance: day.precipitationChance, humidity: day.maximumHumidity, uvIndex: day.uvIndex, recomendationDegree: i.recommendation)
                    weatherResponses.append(recommendedDay)
                }
            }
        }
        
        weatherResponses.sort { $0.recomendationDegree > $1.recomendationDegree }
        
        return weatherResponses
        
    }
}
