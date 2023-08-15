import Foundation
import Combine
import Factory

/// View model responsible for managing events.
@MainActor
class EventViewModel: ObservableObject {
    
    /// The list of events.
    @Published var events = [Event]()
    
    /// A flag indicating if the preview mode is active.
    @Published var preview: Bool
    
    /// The event that has been changed.
    @Published var changedEvent: Event?
    
    /// The event that has been moved.
    @Published var movedEvent: Event?
    
    /// An error message in case of an error.
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    @Injected(\.eventRepository)
    private var eventsRepository: EventRepository
    
    /// Initializes the event view model.
    /// - Parameter preview: A flag indicating if the preview mode is active.
    init(preview: Bool = false) {
        self.preview = preview
        fetchEvents()
    }
    
    /// Fetches the events based on the preview mode.
    func fetchEvents() {
        if preview {
            events = Event.sampleEvents
        } else {
            // Load from the persistence store
            eventsRepository
                .$events
                .assign(to: &$events)
        }
    }
    
    /// Clears the currently changed event.
    func clearChangedEvent() {
        changedEvent = nil
    }
    
    /// Deletes an event.
    /// - Parameter event: The event to delete.
    func delete(_ event: Event) {
        if preview {
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                changedEvent = events.remove(at: index)
            }
        } else {
            changedEvent = eventsRepository.removeEvent(event)
        }
    }
    
    /// Adds an event.
    /// - Parameter event: The event to add.
    func add(_ event: Event) {
        if preview {
            events.append(event)
            changedEvent = event
        } else {
            do {
                try eventsRepository.addEvent(event)
                errorMessage = nil
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            changedEvent = event
        }
    }
    
    /// Updates an event.
    /// - Parameter event: The event to update.
    func update(_ event: Event) {
        do {
            movedEvent = event
            try eventsRepository.updateEvent(event)
            changedEvent = event
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
}
