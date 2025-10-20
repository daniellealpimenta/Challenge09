//
//  HomeView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 20/10/25.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct HomeView: View {
    @State var allActivities: [Activity] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.cyan, Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        NavigationLink(destination: AddNewActivityView(allActivities: $allActivities)) {
                            ZStack {
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.9), Color.orange.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 360, height: 120)
                                .cornerRadius(25)
                                .shadow(color: .yellow.opacity(0.3), radius: 8, x: 0, y: 4)
                                
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
                        
                        HStack {
                            Text("Rolês marcados")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button {
                                // Futura ação
                            } label: {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // Cards das atividades
                        VStack(spacing: 16) {
                            ForEach(allActivities) { activity in
                                ActivityCard(
                                    day: Date(),
                                    activityName: activity.name,
                                    degrees: 28,
                                    newSuggestions: false
                                )
                            }
                            
                            // Exemplo fixo
                            ActivityCard(
                                day: Date(),
                                activityName: "Piquenique",
                                degrees: 28,
                                newSuggestions: false
                            )
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
