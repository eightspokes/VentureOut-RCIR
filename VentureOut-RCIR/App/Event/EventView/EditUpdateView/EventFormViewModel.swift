//
// Created for UICalendarView_SwiftUI
// by Stewart Lynch on 2022-06-29
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

class EventFormViewModel: ObservableObject {
    @Published var date = Date()
    @Published var note = ""
    @Published var eventType: Event.EventType = .unspecified

    var id: UUID? // Only exists if we updating
    var updating: Bool { id != nil }
    // If we create new Event
    init() {}
  
    init(_ event: Event) {
        date = event.date
        note = event.note
        eventType = event.eventType
        id = event.id
    }
    // Desable Update and Create button if any of my fields are empty.
    var incomplete: Bool {
        note.isEmpty 
    }
}
