// This view allows users to create or update events using a dual-purpose form.
// The concept of creating dual-purpose forms was described by Stewart Lynch.
// Learn more at: https://www.youtube.com/c/stewartlynch
// Follow on Twitter: https://twitter.com/stewartlynch?lang=en

import SwiftUI

/// A view for creating or updating events using a form.
struct EventFormView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool?
    
    /// The event to be edited or updated.
    @State public var event: Event
    /// A flag indicating whether the form is for updating an existing event.
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
                        ForEach(Event.EventType.allCases) { eventType in
                            Text(eventType.icon + " " + eventType.rawValue.capitalized)
                                .tag(eventType)
                        }
                    }
                    Section(
                        footer: HStack {
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
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(event: Event(eventType: .hike, date: Date(), note: "This is some note"), isUpdating: false)
            .environmentObject(EventViewModel(preview: true))
    }
}




