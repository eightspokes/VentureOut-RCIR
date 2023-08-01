//
//  EventDateView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import SwiftUI

struct EventDateView: View {
    var event: Event
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
