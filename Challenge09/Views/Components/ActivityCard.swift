//
//  ActivityCard.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/10/25.
//

import SwiftUI
import SwiftData

struct ActivityCard: View {
    // Dados passados pela view-pai
    let day: String
    let activityName: String
    let degrees: Int
    let precipitation: Double // espera 0..1 ou 0..100 (tratado no display)
    let newSuggestions: Bool
    let condition: String?
    let symbolName: String?
    let humidity: Int

    // Conveniência para criar a partir de um DaySelectedModel (SwiftData)
    init(
        day: String,
        activityName: String,
        degrees: Int,
        precipitation: Double = 0,
        newSuggestions: Bool = false,
        condition: String? = nil,
        symbolName: String? = nil,
        humidity: Double
    ) {
        self.day = day
        self.activityName = activityName
        self.degrees = degrees
        self.precipitation = precipitation
        self.newSuggestions = newSuggestions
        self.condition = condition
        self.symbolName = symbolName
        self.humidity = Int(humidity)
    }

    init(from model: DaySelectedModel, newSuggestions: Bool = false) {

        self.day = model.date
        self.activityName = model.nameActivity
        self.degrees = Int(model.temperature.rounded())
        self.precipitation = model.precipitationChance <= 1 ? model.precipitationChance * 100 : model.precipitationChance
        self.newSuggestions = newSuggestions
        self.condition = model.condition
        self.symbolName = model.symbolWeather
        self.humidity = Int(model.humidity * 100)
    }

    private var precipitationPercentString: String {
        let percent = max(0, min(100, precipitation))
        return String(format: "%.0f", percent) + "%"
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .frame(width: 360, height: 110)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()

                        Text(day)
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()
                    }

                    Spacer()

                    HStack {
                        Image(systemName: "thermometer.sun.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()

                        Text("\(degrees)°C")
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()
                    }
                }

                HStack {
                    Text(activityName)
                        .font(.body)
                        .foregroundStyle(.white)
                        .bold()

                    Spacer()

                    HStack(spacing: 8) {
                        Image(systemName: newSuggestions ? "sparkles" : "cloud.fill")
                            .foregroundStyle(newSuggestions ? .yellow : .white.opacity(0.7))

                        Text(precipitationPercentString)
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.9))
                            .bold()
                    }
                }

                if let cond = condition {
                    HStack {
                        let condicaoTraduzida = TradutorCondicaoClimatica(rawValue: cond)
                        
                        Text(condicaoTraduzida?.traducao ?? cond.capitalized)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.85))
                        
                        if let symbolName {
                            Image(systemName: "\(symbolName).fill")
                                .font(.body)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.body)
                                .foregroundStyle(.white)
                                .bold()

                            Text("\(humidity)%")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.9))
                                .bold()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        ActivityCard(day: "", activityName: "Piquenique", degrees: 27, precipitation: 0.05, newSuggestions: true, condition: "partlyCloudy", humidity: 20.02)
    }
}
