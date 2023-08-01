//
//  EventRegistrationForm.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import SwiftUI

struct EventRegistrationForm: View {
    @Environment(\.dismiss) var dismiss
    @State private var note: String = ""
    var event: Event
    
   
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Form {
                    Section {
                        Text(event.eventType.rawValue.prefix(1).capitalized + event.eventType.rawValue.dropFirst())
                            } header: {
                            Text("Event Type")
                        }
                    Section("Date/Time"){
                        EventDateView(event: event)
                    }
                    if !event.note.isEmpty{
                        Section("Note"){
                            Text(event.note)
                        }
                    }
                        
                    Section("Note to  Us (optional)"){
                        TextField("Type here",text: $note, axis: .vertical)
                    
                    }
                    
                        
                   //TODO: Try to refactor this
                    Section(footer:
                                HStack {
                        Spacer()
                        Button {
                           
                            dismiss()
                        } label: {
                            Text("Submit")
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    ){}
                }
            }
            .navigationTitle("Event Registration")
            
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

struct EventRegistrationForm_Previews: PreviewProvider {
    static var previews: some View {
        EventRegistrationForm(event: Event(eventType: .rowing, date: Date(), note: "Some event"))
    }
}
