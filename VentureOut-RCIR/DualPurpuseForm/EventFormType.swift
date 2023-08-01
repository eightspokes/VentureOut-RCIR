import SwiftUI

enum EventFormType: Identifiable, View {
    case new
    case update(Event)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    var body: some View {
        switch self {
        case .new:
            return EventFormView(event: Event(date: Date(), note: ""),isUpdating: false)
        case .update(let event):
            return EventFormView(event: event,isUpdating: true)
        }
    }
}
