//
//  ObservableEvent.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/15/23.
//

import Foundation



/// This potentially could be used to fix ensure views that contain Events are updated when event is changed.
class ObservableEvent: ObservableObject {
    @Published var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    static var sampleEvents: [ObservableEvent] {
        
        let fmt = ISO8601DateFormatter()
        return [
            ObservableEvent(event: Event(eventType: .meeting, date: fmt.date(from: "2023-07-01T08:00:42+0000")!, note: "Volunteer meeting")),
            ObservableEvent(event: Event(eventType: .yoga, date: fmt.date(from: "2023-07-01T09:00:42+0000")!, note: "Volunteer meeting")),
            ObservableEvent(event: Event(eventType: .rowing, date: fmt.date(from: "2023-07-01T10:00:42+0000")!, note: "Volunteer meeting"))
        
            
        ]
    }
}
