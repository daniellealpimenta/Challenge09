//
//  SelectActivityView.swift
//  Challenge09
//
//  Created by Filipi Romão on 17/10/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct SelectActivityView: View {

    // MARK: - Dependências principais
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let weatherManager = WeatherManager.shared
    let recommendedDaysManager = RecommendedDays.shared

    let activityMoment: Activity
    let maxDaysToShow: Int
    
    @StateObject var crudVM = CloudKitCRUDViewModel()

    // MARK: - Estados
    @State private var bestDays: [WeatherResponse] = []
    @State private var selectedDayIndex: Int = 0
    @State private var isLoading = true
    @State private var errorMessage: String?

    // MARK: - Corpo da View
    var body: some View {
        
        VStack {
            Text("Atividade: \(activityMoment.name)")
                .font(.title2)
                .padding(.bottom, 10)

            if isLoading {
                ProgressView("Analisando previsões...")
            } else if let errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if bestDays.isEmpty {
                Text("Nenhuma previsão disponível")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    ForEach(Array(bestDays.enumerated()), id: \.offset) { index, day in
                        Button {
                            selectedDayIndex = index
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("📅 \(day.date)")
                                        .font(.headline)
                                    Text("🌡️ Máxima: \(Int(day.temperature))°C")
                                    Text("🌧️ Chuva: \((day.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    Text("☀️ UV: \(day.uvIndex)")
                                    Text("💧 Umidade: \((day.humidity * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    Text("☁️ Condição: \(day.condition.capitalized)")
                                }
                                Spacer()
                                if selectedDayIndex == index {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(index == 0 ? Color.green : (index < 3 ? Color.blue : Color.gray.opacity(0.2)))
                            .foregroundColor(index < 3 ? .white : .primary)
                            .cornerRadius(12)
                        }
                    }
                }

                // Dia selecionado
                Text("Selecionado: \(bestDays[selectedDayIndex].date)")
                    .padding(.top, 15)

                Button {
                    saveSelectedDay()
                } label: {
                    Text("Salvar rolê")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .task {
            await loadRecommendations()
        }
    }

    // MARK: - Funções auxiliares
    private func loadRecommendations() async {
        let allDays = weatherManager.weatherDays

        guard !allDays.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Não foi possível carregar os dados climáticos. Volte à tela inicial."
                self.isLoading = false
            }
            return
        }

        // Considera apenas o limite definido de dias
        let limitedDays = Array(allDays.prefix(maxDaysToShow))

        // Gera recomendações com base na atividade
        let recommendations = await recommendedDaysManager.calculateRecommendations(
            weather: limitedDays,
            activity: activityMoment
        )

        // Gera os objetos WeatherResponse ordenados por melhor recomendação
        let responses = await recommendedDaysManager.generateWeatherResponses(
            weather: limitedDays,
            recommendationDays: recommendations,
            daysCount: maxDaysToShow
        )

        await MainActor.run {
            self.bestDays = responses
            self.isLoading = false
        }
    }

    func saveSelectedDay() {
        guard bestDays.indices.contains(selectedDayIndex) else { return }
        let selected = bestDays[selectedDayIndex]
        
       
        crudVM.name = activityMoment.name
        crudVM.date = selected.date
        crudVM.local = activityMoment.local
        crudVM.descricaoEvento = activityMoment.activityType.rawValue
        crudVM.temperature = selected.temperature
        crudVM.humidity = selected.humidity
        crudVM.uvIndex = selected.uvIndex
        crudVM.symbolWeather = selected.symbolWeather ?? "cloud.fill"
        crudVM.condition = selected.condition
        crudVM.recommendationDegree = selected.recommendationDegree
        crudVM.preciptationChance = selected.precipitationChance

//        let newActivity = DaySelectedModel(
//            nameActivity: activityMoment.name,
//            date: selected.date,
//            temperature: selected.temperature,
//            precipitationChance: selected.precipitationChance,
//            humidity: selected.humidity,
//            uvIndex: selected.uvIndex,
//            condition: selected.condition,
//            symbolWeather: selected.symbolWeather ?? "",
//            recommendationDegree: selected.recommendationDegree
//        )

        
        
        
        do {
            crudVM.addItem()
        } catch {
            print("❌ Erro ao salvar: \(error.localizedDescription)")
        }


        dismiss()
    }
}

