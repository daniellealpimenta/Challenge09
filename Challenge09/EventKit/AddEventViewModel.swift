//
//  AddEventViewModel.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 17/10/25.
//

import Foundation
import EventKit

@Observable
class AddEventViewModel {
    var events = [Event]()
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    // Pede autorização e, se concedida, adiciona o novo evento ao calendário
    func addNewEvent(_ event: Event) async {
        // Objeto que acessa os eventos e lembretes do calendário e suporta o agendamento de novos eventos
        let eventStore = EKEventStore()
        
        // Pede permissão
        do {
            let granted = try await eventStore.requestWriteOnlyAccessToEvents()
            if granted {
                print("Permissão aceita")
            } else {
                print("Permissão negada")
            }
        } catch {
            print("Erro ao requisitar permissão: \(error.localizedDescription)")
        } 
        
        // Passa os dados do novo evento
        let calendarEvent = EKEvent(eventStore: eventStore)
        calendarEvent.title = event.title
        calendarEvent.startDate = event.date
        calendarEvent.endDate = event.date.addingTimeInterval(3600)
        calendarEvent.notes = event.description
        calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        // Adiciona o evento
        do {
            try eventStore.save(calendarEvent, span: .thisEvent)
            alertTitle = "Evento salvo!"
            alertMessage = "Seu evento foi salvo no calendário"
            events.append(event)
        } catch {
            print("Erro ao salvar evento: \(error.localizedDescription)")
            alertTitle = "Erro ao salvar"
            alertMessage = "Seu evento não pode ser salvo."
        }
    }
}
