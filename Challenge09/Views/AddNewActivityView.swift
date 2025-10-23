//
//  AddNewActivityView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 16/10/25.
//

import SwiftUI

struct AddNewActivityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var maxDays = 1
    @State private var activityType: ActivityType = .walkingDog
    @State private var newActivity: Activity = .init(name: "", maxDays: 1, activityType: .walkingDog)
    @State private var showSelectActivity = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section("Como deseja chamar esse rolê?") {
                    TextField("Ex: Parque com os amigos", text: $newActivity.name)
                }
                
                Section("Em até quantos dias?") {
                    Picker("Dias", selection: $newActivity.maxDays) {
                        ForEach(1..<11) { number in
                            Text("\(number) dia\(number == 1 ? "" : "s")")
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Qual o tipo de atividade?") {
                    Picker("Atividade", selection: $newActivity.activityType) {
                        ForEach(ActivityType.allCases, id: \.self) { activity in
                            Text(activity.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                //                Button("Salvar rolê") {
                //                    let newActivity = Activity(
                //                        name: name,
                //                        maxDays: maxDays,
                //                        activityType: activityType)
                //                    allActivities.append(newActivity)
                //                    name = ""
                //                    maxDays = 1
                //                    activityType = .walkingDog
                //                    dismiss()
                //                }
                Button("Ver previsões") {
                        showSelectActivity = true
                    }
                    .disabled(newActivity.name.isEmpty)
                
            }.padding(.top, 20)
            .sheet(isPresented: $showSelectActivity) {
                SelectActivityView(
                    activityMoment: newActivity,
                    maxDaysToShow: newActivity.maxDays
                )
            }
        }
        
        .navigationTitle("Novo rolê")
    }
}
//#Preview {
//    AddNewActivity(
//            allActivities: .constant([
//                Activity(name: "a", maxDays: 2, activityType: .beachDay)
//            ])
//        )
//}

