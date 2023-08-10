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
    @Published var changedEvent: Event?
    @Published var movedEvent: Event?
    @Published var errorMessage: String?
    
 
    // MARK: - Dependencies
    @Injected(\.eventRegistrationRepository) private var eventRegistrationRepository: EventRegistrationRepository
    @Injected(\.auth) private var auth
    @Injected(\.firestore) private var firestore
    
    init(preview: Bool = false) {
       
        self.preview = preview
        fetchEvents()
        print("These are my event registrations in EventRegistrationViewMOdel: \(eventRegistrations.count)")
        
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
    func clearChangedEventRegistration(){
        changedEvent = nil
    }

    func delete(_ eventRegistration: EventRegistration) {
        if preview{
            if let index = eventRegistrations.firstIndex(where: {$0.id == eventRegistration.id}) {
                 eventRegistrations.remove(at: index)
            }
        }else{
            eventRegistrationRepository.removeEventRegistration(eventRegistration)
        }

    }
    func deleteRegistrationsBy(_ event: Event){
        if preview{
           //TODO: Implement this
        }else{
            eventRegistrationRepository.removeEventRegistrationBy(event)
        }
    }
    func isRegistered(_ user: User, for event: Event) -> EventRegistration? {
        
        for eventRegistration in eventRegistrations {
            if eventRegistration.eventId == event.id && eventRegistration.userId == user.id{
                print("You are already registred for this event!")
                return eventRegistration
            }
        }
        return nil
    }
    
    

    func add(event: Event, user: User, noteToAdmin: String) {
        
        if isRegistered(user, for: event) != nil {
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
                  changedEvent = event
                
                }
                catch {
                  print(error)
                  errorMessage = error.localizedDescription
                }
        
        }
        
        
        
        
    }

    func update(_ eventRegistration: EventRegistration) {
        print("Update event called")
        do {
        //TODO: Handle changed event functionality
            //changedEvent = eventRegistration
            try eventRegistrationRepository.updateEventRegistration(eventRegistration)
           // movedEvent = event
            
            }
            catch {
              print(error)
              errorMessage = error.localizedDescription
            }
    }
}
