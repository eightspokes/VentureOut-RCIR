//
//  NewEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/28/23.
//

import SwiftUI

struct NewEventView: View {
    @EnvironmentObject var eventStore: EventViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    @State var event = Event(date: Date(), note: "")
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
                            eventStore.add(event)
                            dismiss()
                            
                            
                        } label: {
                            Text("Add Event")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(event.note.isEmpty)
                        Spacer()
                    }
                    )
                    {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("New Event")
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
        NewEventView()
            .environmentObject(EventViewModel())
    }
}




