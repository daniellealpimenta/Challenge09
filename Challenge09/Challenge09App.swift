//
//  Challenge09App.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import SwiftUI
import SwiftData

@main
struct Challenge09App: App {
    @State private var locationManager = LocationManager()
    @UIApplicationDelegateAdaptor var appDelegate: PushNotificationDelegate
     
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                HomeView()
                    .onAppear {
                    appDelegate.app = self
                }
            } else {
                LocationDeniedView()
            }
                
        }.environment(locationManager)
            .modelContainer(for: DaySelectedModel.self)
    }
}
