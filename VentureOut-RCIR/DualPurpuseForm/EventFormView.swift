//
//  NewEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/28/23.
//

import SwiftUI

struct EventFormView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    
    @State public var event: Event
    @State public var isUpdating: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    DatePicker(selection: $event.date) {
                        Text("Date and Time")
                    }
                    TextField("Note", text: $event.note, axis: .vertical)
                        .focused($focus, equals: true)
                    Picker("Event Type", selection: $event.eventType) {
                        ForEach(Event.EventType.allCases) {eventType in
                            Text(eventType.icon + " " + eventType.rawValue.capitalized)
                                .tag(eventType)
                        }
                    }
                    Section(footer:
                                HStack {
                        Spacer()
                        Button {
                            isUpdating ? eventViewModel.update(event) : eventViewModel.add(event)
                            dismiss()
                        } label: {
                            Text("Submit")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(event.note.isEmpty)
                        Spacer()
                    }
                    ){}
                }
            }
            .navigationTitle(isUpdating ? "Update Event" : "New Event")
            .onAppear {
                focus = true
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(event: Event(eventType: .hike, date: Date(), note: "This is some funny note"), isUpdating: false)
            .environmentObject(EventViewModel(preview: true))
    }
}




