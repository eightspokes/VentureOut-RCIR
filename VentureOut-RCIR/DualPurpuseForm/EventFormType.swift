// The concept of creating dual-purpose forms was described by Stewart Lynch.
// Learn more at: https://www.youtube.com/c/stewartlynch
// Follow on Twitter: https://twitter.com/stewartlynch?lang=en


import SwiftUI

/// An enumeration representing different forms for creating or updating events.
enum EventFormType: Identifiable, View {
    /// Represents a form for creating a new event.
    case new
    /// Represents a form for updating an existing event.
    case update(Event)
    
    /// The unique identifier for the form type.
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    /// Generates the appropriate view based on the form type.
    ///
    /// - Returns: A SwiftUI view for event creation or update.
    var body: some View {
        switch self {
        case .new:
            return EventFormView(event: Event(date: Date(), note: ""), isUpdating: false)
        case .update(let event):
            return EventFormView(event: event, isUpdating: true)
        }
    }
}
