//
//  UpdateEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/29/23.
//

import SwiftUI

struct UpdateEventView: View {
    @EnvironmentObject var eventStore: EventViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    @Binding var event: Event
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
                            eventStore.update(event)
                            dismiss()
                            
                            
                        } label: {
                            Text("Update Event")
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

//struct UpdateEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateEventView(event: <#T##Binding<Event>#>)
//            .environmentObject(EventViewModel())
//    }
//}


