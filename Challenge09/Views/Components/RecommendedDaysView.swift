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
            // Apenas remova o '$' daqui.
            ForEach(bestDays) { day in
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("📅 Dia: \(day.date)")
                        .font(.subheadline)
                    Text("🌡️ Temperatura: \(day.temperature, specifier: "%.1f")°C")
                    Text("☔️ Chance de chuva: \(day.precipitationChance * 100, specifier: "%.0f")%")
                    Text("🔆 UV Index: \(day.uvIndex)")
                    Text("⭐️ Recomendação: \(day.recomendationDegree)% / 100%")
                        .bold()
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
