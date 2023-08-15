//
//  EventDateView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import SwiftUI

/// A view to display the date and time of an event using a given `Event` object.
struct EventDateView: View {
    /// The event for which the date is displayed.
    var event: Event
    
    /// A date formatter to format the event's date and time.
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Text(dateFormatter.string(from: event.date))
    }
}
