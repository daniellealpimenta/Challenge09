//
//  DescribeActivityView.swift
//  Challenge09
//
//  Created by Filipi Romão on 23/10/25.
//

import SwiftUI

struct DescribeActivityView: View {
    let foudationManager = FoundationManager()
    var passeio: PasseioModel

    @State var input: String = ""
    @State var message: String?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.8), Color.cyan, Color.white,
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                Image(systemName: "\(passeio.symbolWeather)")
                    .frame(width: 120)
                    .font(.system(size:  60))
                Text("Escolha bem sua roupa")
                    .font(.title)

                Text("\(passeio.name)")
                    .font(.headline)
                HStack(spacing: 16) {
                    VStack(spacing: 16){
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.body)
                                .foregroundStyle(.white)
                            Text(passeio.date)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        HStack(spacing: 24){
                            HStack(spacing: 6) {
                                Image(systemName: "thermometer.sun.fill")
                                    .font(.body)
                                    .foregroundStyle(.white)
                                Text("\(passeio.temperature, specifier: "%.0f")°C")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }

                            HStack(spacing: 6) {
                                Image(systemName: "drop.fill")
                                    .font(.body)
                                    .foregroundStyle(.white)
                                Text("\(passeio.humidity*100, specifier: "%.2f")%")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }

                            HStack(spacing: 6) {
                                Image(systemName: "cloud.rain.fill")
                                    .font(.body)
                                    .foregroundStyle(.white)
                                Text("\(passeio.precipitationChance, specifier: "%.0f")%")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                            }
                        }
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse.circle.fill")
                                .font(.body)
                                .foregroundStyle(.white)
                            Text(passeio.local)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                   
                }
                .frame(width: 300)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 2)
                VStack {
                    Button(
                        action: {
                            input = """
                                You are a clothing expert.  
                                Your task is to choose the most appropriate type of clothing based on the weather conditions, temperature, and type of outing.

                                Follow the instructions below carefully:  
                                - Hot or sunny days (temperature above 25°C) require light clothing (shorts, light shirts, sandals).  
                                - Mild or cool days (temperature between 15°C and 25°C) or windy weather require warm clothing (jackets, pants, sneakers).  
                                - Cold days (temperature below 15°C) or rainy/humid weather require rain clothing (waterproof jackets, raincoats, closed shoes).

                                Based on the information below, choose only one of the three options.  
                                Do not add explanations, emojis, or extra text — respond only with the exact clothing type.

                                Weather type: \(passeio.condition)  
                                Temperature: \(passeio.temperature)°C  

                                Respond in **Portuguese** with exactly one of the following options:

                                1. Roupas leves (shorts, blusas leves, sandálias)  
                                2. Roupas quentes (casacos, calças, tênis)  


                                """

                            Task {
                                message =
                                    try? await foudationManager
                                    .generateWeatherMessage(
                                        for: input
                                    )
                            }
                        },
                        label: {
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.yellow.opacity(0.9),
                                        Color.orange.opacity(0.8),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 360, height: 80)
                                .cornerRadius(25)
                                .shadow(
                                    color: .yellow.opacity(0.3),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                                VStack(spacing: 5) {
                                    Text("Recomendar Roupa")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                .frame(height: 40)
                            }
                        }
                    )

                }
                if let message {
                    Text("A roupa ideal é: \(message)")
                }

            }

        }
    }
}
