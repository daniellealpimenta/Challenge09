//
//  Challenge09App.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import SwiftUI

@main
struct Challenge09App: App {
    @State private var locationManager = LocationManager()
    @UIApplicationDelegateAdaptor var appDelegate: PushNotificationDelegate 
     
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ContentView()
                    .onAppear {
                    appDelegate.app = self
                }
            } else {
                LocationDeniedView()
            }
                
        }.environment(locationManager)
    }
}
