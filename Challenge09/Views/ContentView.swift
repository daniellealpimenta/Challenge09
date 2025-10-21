//
//  ContentView.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

// 15,79284° S, 47,88249° O

import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @Environment(LocationManager.self) var locationManager
    @State private var selectedCity: City?
    
    let weatherManager = WeatherManager.shared
    let recommendedDaysManager = RecommendedDays.shared
    
    @State private var bestDays: [WeatherResponse]?
    
    @State private var weather: Weather?
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedCity {
                    if isLoading {
                        ProgressView()
                        Text("Fazendo requisição do Clima...")
                    } else {
                        Text(selectedCity.name)
                            .font(.title)
                            .padding()
                        
                        if let weather {
                            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                            Text(Date.now.formatted(date: .omitted, time: .shortened))
                            Image(systemName: weather.currentWeather.symbolName)
                                .renderingMode(.original)
                                .symbolVariant(.fill)
                                .font(.system(size: 60.0, weight: .bold))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.secondary.opacity(0.2))
                                )
                            let temp = weatherManager.temperatureFormatter.string(from: weather.currentWeather.temperature)
                            Text(temp)
                                .font(.title2)
                            Text(weather.currentWeather.condition.description)
                                .font(.title3)
                            AttributionView()
                            Text(weatherManager.weatherDays.count.description + " dias de previsão")
                            NotificationButton()
                            HomeView()
                        }

                        //if let bestDays {
                        //    RecommendedDaysView(bestDays: bestDays)
                        //}
                        
                        NavigationLink(destination: AddNewActivityView(), label: {
                            Text("Adicionar novo rolê")
                        })
                        
                        NavigationLink(destination: AllActivitiesView(), label: {
                            Text("Todos os rolês")
                        })
                    }
                }
            }
        }.padding()
            .task(id: locationManager.currentLocation) {
                if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                    selectedCity = currentLocation
                }
            }
        
            .task(id: selectedCity) {
                if let selectedCity {
                    await fetchWeatherView(for: selectedCity)
                }
            }
        
          .task(id: weatherManager.weatherDays.count) {
              if !weatherManager.weatherDays.isEmpty {
                  let recomendations =  await recommendedDaysManager.calculateRecommendations(weather: weatherManager.weatherDays)

                  if !recomendations.isEmpty {
                      bestDays = await recommendedDaysManager.generateWeatherResponses(weather: weatherManager.weatherDays, recommendationDays: recomendations)

                  }

  //                print("✅ Foram carregados \(weatherManager.weatherDays.count) dias:")
  //                for day in weatherManager.weatherDays {
  //                    print("📅 Date: \(day.dateWeather) | 🌡️ Temperatura: \(day.highestTemperature)°C | ☔️ Chance de chuva: \(day.precipitationChance)% | 🔆 UV Index: \(day.uvIndex) | 🌧️ Humidade: \(day.maximumHumidity)%")
  //                }
              }
        }
    }
    
    
    func fetchWeatherView(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            weather = await weatherManager.fetchWeather(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    ContentView()
        .environment(LocationManager())
}
