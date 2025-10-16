//
//  AddNewActivityView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 16/10/25.
//

import SwiftUI

struct AddNewActivity: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var maxDays = 1
    @State private var activityType: ActivityType = .walkingDog
    @Binding var allActivities: [Activity]
    
    var body: some View {
            Form {
                Section("Como deseja chamar esse rolê?") {
                    TextField("Ex: Parque com os amigos", text: $name)
                }
                
                Section("Em até quantos dias?") {
                    Picker("Dias", selection: $maxDays) {
                        ForEach(1..<11) { number in
                            Text("\(number) dia\(number == 1 ? "" : "s")")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Qual o tipo de atividade?") {
                    Picker("Atividade", selection: $activityType) {
                        ForEach(ActivityType.allCases, id: \.self) { activity in
                            Text(activity.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Button("Salvar rolê") {
                    let newActivity = Activity(
                        name: name,
                        maxDays: maxDays,
                        activityType: activityType)
                    allActivities.append(newActivity)
                    name = ""
                    maxDays = 1
                    activityType = .walkingDog
                    dismiss()
                }
            }
        
        .navigationTitle("Novo rolê")
    }
}
#Preview {
    AddNewActivity(
            allActivities: .constant([
                Activity(name: "a", maxDays: 2, activityType: .beachDay)
            ])
        )
}

