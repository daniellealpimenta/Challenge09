//
//  Challenge09App.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 14/10/25.
//

import SwiftUI

@main
struct Challenge09App: App {
    
    @UIApplicationDelegateAdaptor var appDelegate: PushNotificationDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    appDelegate.app = self
                }
        }
    }
}
