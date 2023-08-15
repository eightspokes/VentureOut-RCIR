//
//  RowersRegisteredForEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/12/23.
//

import SwiftUI

/// A view that displays a list of rowers registered for a specific event.
struct RowersRegisteredForEventView: View {
    /// A flag indicating whether this view is in preview mode.
    var preview: Bool?
    
    /// An array of event registrations.
    var eventRegistrations: [String]
    
    /// A private state variable to store the fetched user data.
    @State private var fetchedUsers: [User] = []
    
    /// A property to dismiss the view.
    @Environment(\.dismiss) var dismiss
    
    /// The view model responsible for managing event registrations.
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    
    var body: some View {
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
            fetchedUsers = eventRegistrationViewModel.getUsers(for: eventRegistrations)
            print("This is my fetched users in Rowers registered view \(fetchedUsers)")
        }
    }
}

struct RowersRegisteredForEventView_Previews: PreviewProvider {
    static var previews: some View {
        RowersRegisteredForEventView(preview: true, eventRegistrations: [""])
    }
}
