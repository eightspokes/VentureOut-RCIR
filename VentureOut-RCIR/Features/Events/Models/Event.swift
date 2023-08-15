import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

/// A struct representing an event in the application.
struct Event: Identifiable, Codable , Equatable{
    
    /// The document ID from Firestore.
    @DocumentID var id: String?
    
    /// The type of the event.
    var eventType: EventType
    
    /// The date and time of the event.
    var date: Date
    
    /// A note describing the event.
    var note: String
    
    /// An array of user IDs who are registered for the event.
    var eventRegistrations = [String]()
    
    /// The types of events.
    enum EventType: String, Identifiable, CaseIterable, Codable {
        case rowing, yoga, hike, meeting, unspecified
        
        /// The identifier for the enum.
        var id: String {
            self.rawValue
        }

        /// The corresponding emoji icon for the event type.
        var icon: String {
            switch self {
            case .rowing:
                return "🚣‍♀️"
            case .yoga:
                return "🧘‍♀️"
            case .hike:
                return "🥾"
            case .meeting:
                return "📋"
            case .unspecified:
                return "❈"
            }
        }
    }
    
    /// The date components of the event's date and time.
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }

    /// Initializes an event with specified parameters.
    /// - Parameters:
    ///   - eventType: The type of the event.
    ///   - date: The date and time of the event.
    ///   - note: A note describing the event.
    init(eventType: EventType = .unspecified, date: Date, note: String) {
        self.eventType = eventType
        self.date = date
        self.note = note
    }

    /// Provides sample events for preview purposes.
    static var sampleEvents: [Event] {
        let fmt = ISO8601DateFormatter()
        return [
            Event(eventType: .meeting, date: fmt.date(from: "2023-07-01T08:00:42+0000")!, note: "Volunteer meeting"),
            Event(eventType: .hike, date: fmt.date(from: "2023-07-02T08:00:42+0000")!, note: "Hike"),
            Event(eventType: .rowing, date: fmt.date(from: "2023-07-03T08:00:42+0000")!, note: "Rowing"),
            Event(eventType: .yoga, date: fmt.date(from: "2023-07-04T08:00:42+0000")!, note: "Yoga class"),
            Event(eventType: .unspecified, date: fmt.date(from: "2023-07-05T08:00:42+0000")!, note: "Cleaning day")
        ]
    }
}

/// Extension to provide the collection name for the Event struct in Firebase.
extension Event {
    static let collectionName = "events"
}
