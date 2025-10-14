//
//  LocationDeniedView.swift
//  Challenge09
//
//  Created by Wise on 14/10/25.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("Localização Indisponivel", systemImage: "gear")
        }, description: {
            Text("").multilineTextAlignment(.leading)//adicionar instrucoes
            
        }, actions: {
            Button(action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil
                )
            }) {
                Text("Abrir Ajustes")
            } .buttonStyle(.borderedProminent)
        })
        
    }
}


