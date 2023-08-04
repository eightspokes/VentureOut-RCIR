

import Foundation
import Combine
import Factory

@MainActor
class EventViewModel: ObservableObject {
    @Published var events = [Event]()
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
            changedEvent = eventsRepository.removeEvent(event)
        }  
    }

    func add(_ event: Event) {
        if preview{
            events.append(event)
            changedEvent = event
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
        do {
            movedEvent = event
            try eventsRepository.updateEvent(event)
            changedEvent = event
            }
            catch {
              print(error)
              errorMessage = error.localizedDescription
            }
    }

}
