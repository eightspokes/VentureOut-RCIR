//
//  RegisterRowersView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/11/23.
//

import SwiftUI

struct RegisterRowersView: View {
    var preview: Bool?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fetchedUsers: [User] = []
    @State private var searchText = ""
    var event: Event
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return fetchedUsers
        } else {
            return fetchedUsers.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    
    
    private func fetchUsers() {
        
        if let preview {
            if preview{
                fetchedUsers =  [User(id: UUID().uuidString, fullName: "Roman " , email: "someemail@gmail.com"), User(id: UUID().uuidString, fullName: "Roman " , email: "someemail@gmail.com"), User.init(id: UUID().uuidString, fullName: "aaa ", email: "bbb")]
                
            }
            return
        }
        authViewModel.fetchAllUsers { users in
            fetchedUsers = users
        }
    }
    
    
    
    var body: some View {
        
        NavigationStack {
            
            List {
                //                Section ("Event"){
                //                    VStack(alignment: .leading){
                //                        Text(event.eventType.icon)
                //                            .font(.system(size: 20))
                //                        Text(event.note)
                //                            .font(.title3)
                //
                //                        Text(event.date.formatted(date: .abbreviated,time: .shortened))
                //                            .font(.subheadline)
                //
                //                    }
                //                }
                Section("Rowers"){
                    
                    
                    
                    ForEach(filteredUsers.sorted {$0.fullName > $1.fullName }) { user in
                        HStack{
                            ProfilePictureView()
                                .scaleEffect(x: 0.75, y: 0.75)
                            VStack(alignment: .leading){
                                Text(user.fullName)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.caption)
                            }
                            Spacer()
                            let eventRegistration = eventRegistrationViewModel.isRegistered(user, for: event)
                            Button {
                                if eventRegistration == nil {
                                    eventRegistrationViewModel.add(event: event, user: user, noteToAdmin: " Registered by \(authViewModel.currentUser!.fullName)")
                                }else{
                                    if let eventRegistration = eventRegistrationViewModel.isRegistered(user, for: event){
                                        eventRegistrationViewModel.delete(eventRegistration)
                                    }
                                }
                                
                            } label: {

                                Text(eventRegistration != nil ? "Remove" : "Add " )
                                    .font(.system(size: 15))
                            }
                            .buttonStyle(.bordered)
                            .buttonStyle(.bordered)
                            
                        }
                        
                        
                    }
                }
            }
            
            .navigationTitle("User Registration")
        
            .searchable(text: $searchText)
            .onAppear {
                fetchUsers()
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
    
    
    
    
    
    struct RegisterRowersView_Previews: PreviewProvider {
        static var previews: some View {
            RegisterRowersView(preview: true, event: Event(date: Date(), note: "Note"))
                .environmentObject(AuthViewModel(preview: true))
                .environmentObject(EventRegistrationViewModel(preview: true))
        }
    }
}
