//
//  SelectActivityView.swift
//  Challenge09
//
//  Created by Filipi Romão on 17/10/25.
//

import SwiftUI
import SwiftData

struct SelectActivityView: View {
    @Environment(\.modelContext) private var modelContext
    let activityMoment: Activity
    
    
    let mockWeatherData: [WeatherDataModelMock] = [
        WeatherDataModelMock(
            date: "2025-10-17",
            temperature: 28.5,
            precipitationChance: 0.2,
            humidity: 65.0,
            uvIndex: 7,
            recomendationDegree: 8
        ),
        WeatherDataModelMock(
            date: "2025-10-18",
            temperature: 25.3,
            precipitationChance: 0.6,
            humidity: 80.0,
            uvIndex: 4,
            recomendationDegree: 5
        ),
        WeatherDataModelMock(
            date: "2025-10-19",
            temperature: 30.1,
            precipitationChance: 0.1,
            humidity: 55.0,
            uvIndex: 9,
            recomendationDegree: 9
        )
    ]
    
    @State var selectedDay: Int = 0

    
    var body: some View {
        
        VStack{
            Text("Nome do role: \(activityMoment.name)")
            ForEach(Array(mockWeatherData.enumerated()), id: \.offset) {index,data in
                
                Button(action: {
                    selectedDay = index
                    print(mockWeatherData[selectedDay].humidity)
                }, label: {
                    HStack{
                        VStack{
                            Text("Dia: \(data.date)")
                            Text("Temperatura: \(data.temperature)")
                            Text("Chance de chuva: \(data.precipitationChance)")
                        }
                    }.padding()
                })
            }
            Text("O dia que eu escolhi foi: \(mockWeatherData[selectedDay].date)")
            Button(action:{
                let newAcitivity = DaySelectedModel(
                    nameActivity: activityMoment.name,
                    date: mockWeatherData[selectedDay].date,
                    temperature: mockWeatherData[selectedDay].temperature,
                    preciptationChance: mockWeatherData[selectedDay].precipitationChance,
                    uvIndex: mockWeatherData[selectedDay].uvIndex)
                
                modelContext.insert(newAcitivity)
                try? modelContext.save()
                
                print("Botao funcionando")
            }, label: {
                Text("Salvar role")
            })
        }
        
                
    }
    
}

//#Preview {
//    SelectActivityView()
//}
