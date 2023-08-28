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
    
        
        let eventRegistration = EventRegistration( user: user, eventId: eventId, eventType: event.eventType, date: event.date, note: event.note, userId: user.id, fullName: user.fullName, email: user.email, noteToAdmin: noteToAdmin)
        
        
        
        
        if preview{
            eventRegistrations.append(eventRegistration)
        }else{
            do {
                
                try eventRegistrationRepository.addEventRegistration(eventRegistration)
                  errorMessage = nil
                  changedEvent = event
                // Send an email that registration was added
                
                let subject = "Registration for Rowing at RCIR"
                let registrationMessage = """
                Dear \(user.fullName),
                We are writing to confirm your registration for rowing at Rochester Community Inclusive Rowing on \(String(describing: event.dateComponents.date)) at  \(String(describing: event.dateComponents.hour)).\(String(describing: event.dateComponents.minute)).
                We are thrilled that you have chosen to join us for this exciting and inclusive activity.

                
                Please make sure to arrive at least 10 minutes before the scheduled start time to ensure a smooth check-in process and to receive any necessary instructions.
                Our team of dedicated instructors and volunteers will be there to assist you throughout the session.

                What to bring:

                Comfortable workout attire
                A reusable water bottle to stay hydrated
                If you have any specific questions or if there have been any changes to your availability, please don't hesitate to contact our registration team at [Contact Email] or [Contact Phone Number].

                We look forward to welcoming you to the Rochester Community Inclusive Rowing community and sharing an enjoyable rowing experience with you. Your participation contributes to the inclusivity and vibrancy of our rowing program, and we're excited to have you on board.

                Thank you for choosing Rochester Community Inclusive Rowing. We can't wait to see you on the water!

                Best regards,

                [Your Name]
                [Your Title]
                Rochester Community Inclusive Rowing
                [Contact Email]
                [Contact Phone Number]
                """
               
                EmailController.shared.sendEmail(subject: subject, body: registrationMessage, to: user.email)
                
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
extension EventRegistrationViewModel {
    func getUsers(for eventRegistrationIds: [String]) -> [User] {
        var users: [User] = []
        
        for eventRegistration in eventRegistrations {
            if eventRegistrationIds.contains(eventRegistration.id ?? "") {
                users.append(eventRegistration.user)
            }
        }
        
        return users
    }
}
