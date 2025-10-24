//
//  HomeView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/10/25.
//

import CoreLocation
import SwiftData
import SwiftUI
import WeatherKit

struct HomeView: View {
    @Environment(LocationManager.self) var locationManager
    let weatherManager = WeatherManager.shared

    @State private var selectedCity: City?
    @State private var weather: Weather?
    @State private var isLoading = true

    @State private var showAddActivity = false
    
    @StateObject var cloudKitVM = CloudKitManager()
    @StateObject var CRUDvm = CloudKitCRUDViewModel()
    @StateObject var notificationVM = pushNotificationManager()

    @Query(sort: \DaySelectedModel.date, order: .reverse)
    private var allActivities: [DaySelectedModel]

    var body: some View {
        NavigationStack {
            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Carregando clima da sua região...")
                        .font(.headline)

                    if locationManager.currentLocation == nil {
                        Text(
                            "Por favor, verifique se os serviços de localização estão ativos para o app."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                    }
                }
                .padding()

            } else if weather != nil {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.8), Color.cyan, Color.white,
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            Button {
                                showAddActivity = true
                            } label: {
                                ZStack {
                                    LinearGradient(
                                        colors: [
                                            Color.yellow.opacity(0.9),
                                            Color.orange.opacity(0.8),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(width: 360, height: 120)
                                    .cornerRadius(25)
                                    .shadow(
                                        color: .yellow.opacity(0.3),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )

                                    VStack(spacing: 5) {
                                        Image(systemName: "sun.max.fill")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                        Text("Novo rolê")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .sheet(isPresented: $showAddActivity, onDismiss: {
                                Task {
                                    CRUDvm.fetchItems() 
                                }
                            }) {
                                AddNewActivityView()
                            }


                            HStack {
                                Text("Rolês marcados")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)

                                Spacer()

                                //                                Button {
                                //                                } label: {
                                //                                    Image(systemName: "arrow.clockwise.circle.fill")
                                //                                        .font(.title3)
                                //                                        .foregroundStyle(.white.opacity(0.9))
                                //                                }
                            }
                            .padding(.horizontal, 25)
                            ScrollView{
                                VStack(spacing: 16) {
                                    ForEach(CRUDvm.passeios, id:\.self) { activity in
                                        NavigationLink(destination: DescribeActivityView(passeio: activity), label: {
                                            ActivityCard(day: activity.date, activityName: activity.name, degrees: activity.recommendationDegree, temperature: activity.temperature, precipitation: activity.precipitationChance, newSuggestions: false, condition: activity.condition, symbolName: activity.symbolWeather, humidity: activity.humidity)
                                        })
                                    }
                                }
                            }
                            .padding(.bottom, 30)
                        }
                        .padding(.top, 10)
                    }
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(selectedCity?.name ?? "Carregando...")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .frame(height: 80)
                    }
                }

            } else {
                VStack {
                    Text("Não foi possível carregar o clima.")
                        .font(.headline)
                    Text("Verifique sua conexão e tente novamente.")
                        .font(.subheadline)
                    Button("Tentar Novamente") {
                        // Força uma nova tentativa de busca
                        Task {
                            await fetchWeather()
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            notificationVM.requestNotificationPermission()
            
            print("🗂 SwiftData carregou \(allActivities.count) atividades")
            for act in allActivities {
                print(
                    "📅 \(act.date) - \(act.nameActivity) - \(act.temperature)°C"
                )
            }
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation,
                selectedCity == nil
            {
                selectedCity = currentLocation
            }
        }
        .task(id: selectedCity) {
            if selectedCity != nil {
                await fetchWeather()

                print(
                    "✅ Foram carregados \(weatherManager.weatherDays.count) dias:"
                )
                for day in weatherManager.weatherDays {
                    print(
                        "📅 Date: \(day.dateWeather) | 🌡️ Temperatura: \(day.highestTemperature)°C | ☔️ Chance de chuva: \(day.precipitationChance)% | 🔆 UV Index: \(day.uvIndex) | 🌧️ Humidade: \(day.maximumHumidity)%"
                    )
                }
            }
        }
    }

    @MainActor
    func fetchWeather() async {
        guard let selectedCity = selectedCity else { return }

        isLoading = true
        weather = await weatherManager.fetchWeather(
            for: selectedCity.clLocation
        )
        isLoading = false
    }
}

#Preview {
    HomeView()
        .environment(LocationManager())
}
