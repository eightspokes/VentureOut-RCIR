import Foundation
import SwiftUI

struct Event: Identifiable {

    var eventType: EventType
    var date: Date
    var note: String
    var peopleRegistered: [UUID]
    var id: UUID
    
    enum EventType: String, Identifiable, CaseIterable {
        case rowing, yoga, hike, meeting, unspecified
        var id: String {
            self.rawValue
        }

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
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }

    init( id: UUID, eventType: EventType = .unspecified, date: Date, note: String) {
        self.eventType = eventType
        self.date = date
        self.note = note
        self.id = id
        peopleRegistered = [UUID]()
    }

    // Data to be used in the preview
    static var sampleEvents: [Event] {
        
        let fmt = ISO8601DateFormatter()
        return [
            Event(id: UUID(), eventType: .meeting, date: fmt.date(from: "2023-07-01T08:00:42+0000")!, note: "Volunteer meeting"),
        
            Event(id: UUID(), eventType: .hike, date: fmt.date(from: "2023-07-02T08:00:42+0000")!, note: "Hike"),
            Event(id: UUID(), eventType: .rowing, date: fmt.date(from: "2023-07-03T08:00:42+0000")!, note: "Rowing"),
            Event(id: UUID(), eventType: .yoga, date: fmt.date(from: "2023-07-04T08:00:42+0000")!, note: "Yoga class"),
            Event(id: UUID(), eventType: .unspecified, date: fmt.date(from: "2023-07-05T08:00:42+0000")!, note: "Cleaning day")
        ]
    }
}
