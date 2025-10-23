//
//  PushNotificationManager.swift
//  Challenge09
//
//  Created by Daniel Leal PImenta on 23/10/25.
//

import Foundation
import CloudKit
import UserNotifications
import Combine
import UIKit

@MainActor
class pushNotificationManager: ObservableObject {
    
    private let privateDB = CKContainer.default().privateCloudDatabase
    
    // Pedir permissão de notificações
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão: \(error.localizedDescription)")
            } else if granted {
                print("Permissão de notificações concedida")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.subscribeNotification()
            } else {
                print("Permissão de notificações negada")
            }
        }
    }
    
    func subscribeNotification(){
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: "Passeios", predicate: predicate, subscriptionID: "passeio_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Novo passeio adicionado"
        notification.alertBody = "Abra o aplicativo para checar o passeio."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription){ returnedSubscription, returnedError in
            
            if let error = returnedError{
                print(error)
            }else{
                print("sucesso ao se inscrever")
            }
            
        }
    }
}
