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
    
        @State private var selectedDay: Int = 0
        @State private var weatherData: [WeatherModel] = []
        @State private var isLoading = true
        @State private var errorMessage: String?

        @State private var locationManager = LocationManager()
    
        @Environment(\.modelContext) private var modelContext
        let activityMoment: Activity
        let maxDaysToShow: Int

    
    var body: some View {
            VStack {
                Text("Nome do role: \(activityMoment.name)")
                    .font(.title2)
                    .padding(.bottom, 10)

                if isLoading {
                    ProgressView("Buscando clima")
                        .task {
                            await loadWeather()
                        }
                } else if let errorMessage = errorMessage {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if weatherData.isEmpty {
                    Text("Nenhuma previsão disponível")
                } else {
                    ScrollView {
                        ForEach(Array(weatherData.enumerated()), id: \.offset) { index, data in
                            Button {
                                selectedDay = index
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Data: \(data.dateWeather)")
                                            .font(.headline)
                                        Text("Temperatura Máxima: \(Int(data.highestTemperature))° ")
                                        Text("Temperatura Mínima: \(Int(data.lowestTemperature))°")
                                        Text("Chance de chuva: \((data.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                        Text("UV: \(data.uvIndex)")
                                    }
                                    Spacer()
                                    if selectedDay == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }

                    Text("Dia escolhido: \(weatherData[selectedDay].dateWeather)")
                        .padding(.top, 15)

                    Button {
                        saveSelectedDay()
                    } label: {
                        Text("Salvar role")
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
            .onAppear {
                locationManager.starLocationServices()
            }
        }

        private func loadWeather() async {
            guard let location = locationManager.userlocation else {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Não foi possível obter sua localização."
                }
                return
            }

            let weather = await WeatherManager.shared.fetchWeather(for: location)
            await MainActor.run {
                if let _ = weather {
                    let allDays = WeatherManager.shared.weatherDays
                    //estava mostrando o numero selecionada - 1
                    // se for pular o dia atual -> usar o drop first
                    weatherData = Array(allDays.prefix(maxDaysToShow + 1))
                } else {
                    errorMessage = "Falha ao buscar dados do clima."
                }
                isLoading = false
            }


        }

        private func saveSelectedDay() {
            let selected = weatherData[selectedDay]
            let newActivity = DaySelectedModel(
                nameActivity: activityMoment.name,
                date: selected.dateWeather,
                temperature: selected.highestTemperature,
                preciptationChance: selected.precipitationChance,
                uvIndex: selected.uvIndex
            )

            modelContext.insert(newActivity)
            try? modelContext.save()
            print("Salvo: \(newActivity.nameActivity) - \(newActivity.date)")
        }
    }


//var body: some View {
//        
//        VStack{
//            Text("Nome do role: \(activityMoment.name)")
//            ForEach(Array(mockWeatherData.enumerated()), id: \.offset) {index,data in
//                
//                Button(action: {
//                    selectedDay = index
//                    print(mockWeatherData[selectedDay].humidity)
//                }, label: {
//                    HStack{
//                        VStack{
//                            Text("Dia: \(data.date)")
//                            Text("Temperatura: \(data.temperature)")
//                            Text("Chance de chuva: \(data.precipitationChance)")
//                        }
//                    }.padding()
//                })
//            }
//            Text("O dia que eu escolhi foi: \(mockWeatherData[selectedDay].date)")
//            Button(action:{
//                let newAcitivity = DaySelectedModel(
//                    nameActivity: activityMoment.name,
//                    date: mockWeatherData[selectedDay].date,
//                    temperature: mockWeatherData[selectedDay].temperature,
//                    preciptationChance: mockWeatherData[selectedDay].precipitationChance,
//                    uvIndex: mockWeatherData[selectedDay].uvIndex)
//                
//                modelContext.insert(newAcitivity)
//                try? modelContext.save()
//                
//                print("Foi salvo: \(newAcitivity.nameActivity)")
//            }, label: {
//                Text("Salvar role")
//            })
//        }
//        
//                
//    }
//    
//}

//#Preview {
//    SelectActivityView()
//}
