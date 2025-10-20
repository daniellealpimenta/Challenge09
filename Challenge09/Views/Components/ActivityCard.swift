//
//  ActivityCard.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/10/25.
//

import SwiftUI

struct ActivityCard: View {
    @State var day: Date
    @State var activityName: String
    @State var degrees: Int
    @State var newSuggestions: Bool
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: day)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .frame(width: 360, height: 110)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack{
                        Image(systemName: "calendar")
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text(formattedDate)
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()
                        
                    }
                    
                    Spacer()
                    
                    HStack{
                        Image(systemName: "thermometer.sun.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                            .bold()
                        
                        Text("\(degrees)ºC")
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
                    
                    HStack(spacing: 6) {
                        Image(systemName: newSuggestions ? "sparkles" : "cloud.fill")
                            .foregroundStyle(newSuggestions ? .yellow : .white.opacity(0.7))
                        Text(newSuggestions ? "Novas sugestões!" : "Tudo atualizado")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.9))
                            .bold()
                    }
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        ActivityCard(day: Date(), activityName: "Piquenique", degrees: 27, newSuggestions: true)
    }
}
