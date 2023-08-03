

import Foundation
import Combine
import Factory

@MainActor
class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var eventResistrations = [EventRegistration]()
    @Published var preview: Bool
    @Published var changedEvent: Event?
    @Published var movedEvent: Event?
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    @Injected(\.eventRepository)
    private var eventsRepository: EventRepository
    
    init(preview: Bool = false) {
        self.preview = preview
        fetchEvents()
        
    }
   

    func fetchEvents() {
        if preview {
            events = Event.sampleEvents
        } else {
            // load from your persistence store
            eventsRepository
              .$events
              .assign(to: &$events)
            
        }
    }
    func clearChangedEvent(){
        changedEvent = nil
    }

    func delete(_ event: Event) {
        if preview{
            if let index = events.firstIndex(where: {$0.id == event.id}) {
                changedEvent = events.remove(at: index)
            }
        }else{
            eventsRepository.removeEvent(event)
        }  
    }

    func add(_ event: Event) {
        if preview{
            events.append(event)
            print( "appending events in preview")
        }else{
            do {
                
                  try eventsRepository.addEvent(event)
                  errorMessage = nil
                }
                catch {
                  print(error)
                  errorMessage = error.localizedDescription
                }
            changedEvent = event
        }
        
        
    }

    func update(_ event: Event) {
        print("Update event called")
        do {
            try eventsRepository.updateEvent(event)
            }
            catch {
              print(error)
              errorMessage = error.localizedDescription
            }
    }
    func addEventRegistration(event:Event, user: User){
        print("Adding new user to Registration")
        eventsRepository.updateEventRegistration(event: event, user: user)
    }

}
