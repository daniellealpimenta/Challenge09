//
//  AllActivitiesView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 16/10/25.
//

import SwiftUI

struct AllActivitiesView: View {
    @Binding var allActivities: [Activity]
    
    var body: some View {
        List {
            ForEach(allActivities) { activity in
                Section {
                    HStack {
                        Text("Nome: ")
                        Spacer()
                        Text(activity.name)
                    }
                    
                    HStack {
                        Text("Tipo: ")
                        Spacer()
                        Text(activity.activityType.rawValue)
                    }
                }
            }
        }
        
        .navigationTitle("Todos rolês")
    }
}
#Preview {
    AllActivitiesView(
            allActivities: .constant([
                Activity(name: "a", maxDays: 2, activityType: .beachDay)
            ])
        )
}


