//
//  CloudKitManager.swift
//  PushWithFoundation
//
//  Created by Filipi Romão on 21/10/25.
//

import Foundation
import CloudKit
import Combine


class CloudKitManager: ObservableObject{
    
    @Published var isSignedInToIcloud = false
    @Published var error: String = ""
    @Published var permissionStatus = false
    
    init() {
        Task {
            await getIcloudStatus()
            await requestPermission()
        }
    }
    
    func requestPermission() async {
        do {
            let status = try await CKContainer.default().requestApplicationPermission([.userDiscoverability])
            permissionStatus = (status == .granted)
        } catch {
            print("Erro ao pedir permissão: \(error)")
        }
    }
    
    func getIcloudStatus() async {
        do {
            let status = try await CKContainer.default().accountStatus()
            switch status {
            case .available:
                isSignedInToIcloud = true
                break
            case .noAccount:
                error = CloudKitError.icloudAccountNotFound.rawValue
                break
            case .couldNotDetermine:
                error = CloudKitError.icloudAccountNotDeterminated.rawValue
                break
            case .restricted:
                error = CloudKitError.icloudAccountRestricted.rawValue
                break
            default:
                error = CloudKitError.icloudAccountUnknow.rawValue
                break
            }
        } catch {
            self.error = "Erro ao verificar status do iCloud: \(error.localizedDescription)"
        }
    }
    
   
    
    enum CloudKitError: String, LocalizedError {
        case icloudAccountNotFound
        case icloudAccountNotDeterminated
        case icloudAccountRestricted
        case icloudAccountUnknow
    }
    
}
