//
//  RowersRegisteredForEventView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/12/23.
//

import SwiftUI

struct RowersRegisteredForEventView: View {
    var preview: Bool?
    var eventRegistrations: [String]
    @State private var fetchedUsers: [User] = []
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    
    
    
    var body: some View {
        NavigationStack{
            
            
                List{
                Section("Rowers") {
                    ForEach(fetchedUsers.sorted {$0.fullName > $1.fullName }) { user in
                        HStack{
                            ProfilePictureView()
                                .scaleEffect(x: 0.75, y: 0.75)
                            VStack(alignment: .leading){
                                Text(user.fullName)
                                    .font(.headline)
                            }
                           
                            
                        }
                        
                        
                    }
                }
                
            }
                .navigationTitle("Registered")
                .onAppear(){
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
        
    
    private func fetchUsers() {
        
        if let preview {
            if preview{
                fetchedUsers =  [User(id: UUID().uuidString, fullName: "Roman " , email: "someemail@gmail.com"), User(id: UUID().uuidString, fullName: "Roman " , email: "someemail@gmail.com"), User.init(id: UUID().uuidString, fullName: "aaa ", email: "bbb")]
                
            }
            return
        }else {
            fetchedUsers = eventRegistrationViewModel.getUsers(for: eventRegistrations)
        }
     
        
        

    }
}

struct RowersRegisteredForEventView_Previews: PreviewProvider {
    static var previews: some View {
        RowersRegisteredForEventView(preview: true, eventRegistrations: [""])
    }
}
