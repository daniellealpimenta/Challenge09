//
//  NotificationButton.swift
//  Challenge09
//
//  Created by Rebeca Maria de Morais Guimães on 14/10/25.
//

import Foundation
import SwiftUI

struct NotificationButton: View {
    
    var body: some View {
        Button("Permitir notificação") {
            Task {
                await solicitarPermissaoNotificacoes()
                }
            }
        }
    }

func solicitarPermissaoNotificacoes() async {
    let center = UNUserNotificationCenter.current()
    let settings = await center.notificationSettings()
    
    switch settings.authorizationStatus {
    case .authorized, .provisional, .ephemeral:
        print("Notificações autorizadas")
        
    case .denied:
        print("Negado. Redirecionando para ajustes")
        abrirConfiguracoesApp()
        
    case .notDetermined:
        do {
            let autorizado = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if autorizado {
                print("Permissão aprovada")
            } else {
                print("Negado. Redirecionando para ajustes")
                abrirConfiguracoesApp()
            }
        } catch {
            print("Falha ao pedir solicitação: \(error.localizedDescription)")
        }
        
    @unknown default:
        print("Status desconhecido")
    }
}

private func abrirConfiguracoesApp() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


#Preview {
    NotificationButton()
}

