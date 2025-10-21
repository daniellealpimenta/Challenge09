//
//  RecommendedDaysView.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 16/10/25.
//

import SwiftUI

public struct RecommendedDaysView: View {
    
    @State var bestDays: [WeatherResponse]

    public var body: some View {
        
        Text("Foram gerados \(bestDays.count) melhores dias:")
            .font(.headline)
            .padding(.bottom, 4)
        
        ScrollView {
            ForEach($bestDays, id: \.date) { day in
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("📅 Dia: \(day.date.wrappedValue)")
                        .font(.subheadline)
                    Text("🌡️ Temperatura: \(day.temperature.wrappedValue, specifier: "%.1f")°C")
                    Text("☔️ Chance de chuva: \(day.precipitationChance.wrappedValue * 100, specifier: "%.0f")%")
                    Text("💧 Humidade: \(day.humidity.wrappedValue * 100, specifier: "%.0f")%")
                    Text("🔆 UV Index: \(day.uvIndex.wrappedValue)")
                    Text("⭐️ Recomendação: \(day.wrappedValue.recommendationDegree) / 100")
                        .bold()
                    Text("☂️ Condição: \(day.condition.wrappedValue)")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.secondary.opacity(0.15))
                )
                .padding(.vertical, 4)
            }
        }
        .frame(maxHeight: 200)
        .padding(.top, 6)
    }
}

//#Preview {
//    FoundationButton()
//}

