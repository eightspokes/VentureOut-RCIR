//
//  RowersRegisteredForEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/12/23.
//

import SwiftUI

/// A view that displays a list of rowers registered for a specific event.
struct RowersRegisteredForEventView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    
    /// A flag indicating whether this view is in preview mode.
    var preview: Bool?
    
    /// event 
    var event: Event
    
    /// A private state variable to store the fetched user data.
    @State private var fetchedUsers: [User] = []
    
    /// A property to dismiss the view.
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        //Get updated event from eventViewModel
        
        NavigationStack {
            List {
                Section("Rowers") {
                    ForEach(fetchedUsers.sorted { $0.fullName > $1.fullName }) { user in
                        HStack {
                            ProfilePictureView()
                                .scaleEffect(x: 0.75, y: 0.75)
                            VStack(alignment: .leading) {
                                Text(user.fullName)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Registered")
            .onAppear() {
                
                
                
                fetchUsers()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    /// Fetches user data based on event registrations.
    private func fetchUsers() {
        if let preview = preview, preview {
            // Sample data for preview mode.
            fetchedUsers = [
                User(id: UUID().uuidString, fullName: "Roman", email: "someemail@gmail.com"),
                User(id: UUID().uuidString, fullName: "Roman", email: "someemail@gmail.com"),
                User(id: UUID().uuidString, fullName: "aaa", email: "bbb")
            ]
        } else {
            let eventRegistrations = eventViewModel.getEventByID(event.id!)!.eventRegistrations
            fetchedUsers = eventRegistrationViewModel.getUsers(for: eventRegistrations)
            print("This is my fetched users in Rowers registered view \(fetchedUsers)")
        }
    }
}

struct RowersRegisteredForEventView_Previews: PreviewProvider {
    static var previews: some View {
        RowersRegisteredForEventView(preview: true, event: Event( date: Date(), note: ""))
    }
}
