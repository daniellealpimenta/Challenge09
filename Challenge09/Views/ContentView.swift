//
//  ContentView.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("\(weather1.highestTemperature)°C")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
