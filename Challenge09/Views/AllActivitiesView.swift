//
//  AllActivitiesView.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 16/10/25.
//

import SwiftUI
import SwiftData

struct AllActivitiesView: View {
    @Query(FetchDescriptor<DaySelectedModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])) private var activities: [DaySelectedModel]

    var body: some View {
        List {
            ForEach(activities, id: \.id) { activity in
                VStack{
                    HStack {
                        Text("Date:")
                        Spacer()
                        Text(activity.date)
                    }
                    HStack {
                        Text("Nome:")
                        Spacer()
                        Text(activity.nameActivity)
                    }
                }
            }
        }
    }
}

#Preview {
    AllActivitiesView()
        .modelContainer(for: DaySelectedModel.self, inMemory: true)
}
