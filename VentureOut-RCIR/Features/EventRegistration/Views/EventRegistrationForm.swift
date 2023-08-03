//
//  EventRegistrationForm.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import SwiftUI

struct EventRegistrationForm: View {
    @Environment(\.dismiss) var dismiss
    @State private var noteToAdmin: String = ""
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    @EnvironmentObject var authViewModel:  AuthViewModel
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
                        TextField("Type here",text: $noteToAdmin, axis: .vertical)
                    
                    }
                    
                        
                   //TODO: Try to refactor this
                    Section(footer:
                                HStack {
                        Spacer()
                        Button {
                            
                            if let currentUser =
                               
                                authViewModel.currentUser{
                                print("Current user, it \(currentUser)")
                                if let currentUser = authViewModel.currentUser{
                                    eventRegistrationViewModel.add(event: event, user: currentUser, noteToAdmin: noteToAdmin)
                                }
                                
                            }else{
                                print("Can't add current user, it is nil" )
                            }
                            
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
            .environmentObject(EventRegistrationViewModel(preview: true))
            .environmentObject(AuthViewModel(preview: true))
    }
}
