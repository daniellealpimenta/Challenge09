//
//  CustomAppDelegate.swift
//  Challenge09
//
//  Created by Rebeca Maria de Morais Guimães on 14/10/25.
//


import UserNotifications
import SwiftUI
import CloudKit
import UIKit

let subscriptionID = "NotificaClima"

class PushNotificationDelegate: NSObject, UIApplicationDelegate {

    var app: Challenge09App?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

}

extension PushNotificationDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
         didReceive response: UNNotificationResponse) async {
        print("Notificação recebida com o título: \(response.notification.request.content.title)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification)
        async -> UNNotificationPresentationOptions {

        return [.badge, .banner, .list, .sound]
    }


}
