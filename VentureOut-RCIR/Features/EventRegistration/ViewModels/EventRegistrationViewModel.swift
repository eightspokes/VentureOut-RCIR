//
//  EventRegistrationViewModel.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/2/23.
//


import Foundation
import Combine
import Factory


@MainActor
class EventRegistrationViewModel: ObservableObject {
    @Published var eventRegistrations = [EventRegistration]()
    @Published var preview: Bool
    @Published var changedEventRegistration: EventRegistration?
    @Published var movedEvent: EventRegistration?
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    @Injected(\.eventRegistrationRepository) private var eventRegistrationRepository: EventRegistrationRepository
    @Injected(\.auth) private var auth
    @Injected(\.firestore) private var firestore
    
    init(preview: Bool = false) {
        self.preview = preview
        fetchEvents()
        
    }
   

    func fetchEvents() {
        if preview {
            eventRegistrations = EventRegistration.sampleEventRegistration
        } else {
            // load from your persistence store
            eventRegistrationRepository
              .$eventsRegistrations
              .assign(to: &$eventRegistrations)
            
        }
    }
    func clearChangedEvent(){
        changedEventRegistration = nil
    }

    func delete(_ eventRegistration: EventRegistration) {
        if preview{
            if let index = eventRegistrations.firstIndex(where: {$0.id == eventRegistration.id}) {
                changedEventRegistration = eventRegistrations.remove(at: index)
            }
        }else{
            eventRegistrationRepository.removeEventRegistration(eventRegistration)
        }

    }
    
    func isRegistered(_ user: User, for event: Event) -> Bool{
        print("These are my event registrations \(eventRegistrations)")
        //Check if user is already registered for event
        for eventRegistration in eventRegistrations {
            if eventRegistration.eventId == event.id && eventRegistration.userId == user.id{
                print("You are already registred for this event!")
                return true
            }
        }
        return false
    }
    
    

    func add(event: Event, user: User, noteToAdmin: String) {
        
        if isRegistered(user, for: event){
            return
        }
        
        
        
        
        guard let eventId = event.id else {
            print("Error adding new registration, event does not have an ID")
            return
        }
    
        
        let eventRegistration = EventRegistration( eventId: eventId, eventType: event.eventType, date: event.date, note: event.note, userId: user.id, fullName: user.fullName, email: user.email, noteToAdmin: noteToAdmin)
        
        if preview{
            eventRegistrations.append(eventRegistration)
            print( "appending events in preview")
        }else{
            do {
                try eventRegistrationRepository.addEventRegistration(eventRegistration)
                  errorMessage = nil
                }
                catch {
                  print(error)
                  errorMessage = error.localizedDescription
                }
            changedEventRegistration = eventRegistration
        }
        
        
        
        
    }

    func update(_ eventRegistration: EventRegistration) {
        print("Update event called")
        do {
            try eventRegistrationRepository.updateEventRegistration(eventRegistration)
            }
            catch {
              print(error)
              errorMessage = error.localizedDescription
            }
    }
}
