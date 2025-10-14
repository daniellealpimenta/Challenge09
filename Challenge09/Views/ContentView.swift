//
//  ContentView.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(LocationManager.self) var locationManager
    @State private var selectedCity: City?
    var body: some View {
        VStack {
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
        .environment(LocationManager())
}
