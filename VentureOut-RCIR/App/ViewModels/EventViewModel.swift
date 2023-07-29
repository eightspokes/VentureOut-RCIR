

import Foundation
import Combine

@MainActor
class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    
    @Published var preview: Bool
    @Published var changedEvent: Event?
    @Published var movedEvent: Event?
    @Published var errorMessage: String?
    private var eventsRepository: EventRepository =  EventRepository()
    
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
        print("!!!!!!!!!!!This is my EventRepo \(eventsRepository.events.count)")
        print("!!!!!!!!!!!This is my LocalRepo \(self.events.count)")
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
                print("1 ***Callding add event from Event View Model")
                  try eventsRepository.addEvent(event)
                  errorMessage = nil
                print("2 ***Callding add event from Event View Model")
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

}
