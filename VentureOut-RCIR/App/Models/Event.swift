import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    /*
     The @DocumentID property wrapper will populate its property with the document ID when the document is read from Firestore.
     */
    @DocumentID var id: String?
    
    var eventType: EventType
    var date: Date
    var note: String
    var peopleRegistered: [UUID]
    
    
    enum EventType: String, Identifiable, CaseIterable, Codable {
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

    init( eventType: EventType = .unspecified, date: Date, note: String) {
        self.eventType = eventType
        self.date = date
        self.note = note
        
        peopleRegistered = [UUID]()
    }

    // Data to be used in the preview
    static var sampleEvents: [Event] {
        
        let fmt = ISO8601DateFormatter()
        return [
            Event(eventType: .meeting, date: fmt.date(from: "2023-07-01T08:00:42+0000")!, note: "Volunteer meeting"),
        
            Event(eventType: .hike, date: fmt.date(from: "2023-07-02T08:00:42+0000")!, note: "Hike"),
           // Event(eventType: .rowing, date: fmt.date(from: "2023-07-03T08:00:42+0000")!, note: "Rowing"),
//            Event(eventType: .yoga, date: fmt.date(from: "2023-07-04T08:00:42+0000")!, note: "Yoga class"),
//            Event(eventType: .unspecified, date: fmt.date(from: "2023-07-05T08:00:42+0000")!, note: "Cleaning day")
        ]
    }
}
//To be used by Repository to specify collection Name in Firebase
extension Event {
  static let collectionName = "events"
}
