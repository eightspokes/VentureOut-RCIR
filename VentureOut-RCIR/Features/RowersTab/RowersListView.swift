//
//  RowersListView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/10/23.
//

import SwiftUI

struct RowersListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var fetchedUsers: [User] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedUsers.sorted {$0.fullName < $1.fullName }) { user in
                    HStack{
                        ProfilePictureView()
                        VStack(alignment: .leading){
                            Text(user.fullName)
                                .font(.headline)
                            Text(user.email)
                                .font(.caption)
                        }
                        
                    }
                    
                    
                }
            }
            .navigationBarTitle("Rowers")
            .font(.title2)
            
            .onAppear {
                fetchUsers()
            
        }
            
        }
        
    }
    
    private func fetchUsers() {
        authViewModel.fetchAllUsers { users in
            fetchedUsers = users
        }
    }
}



struct RowersListView_Previews: PreviewProvider {
    static var previews: some View {
        RowersListView()
            .environmentObject(AuthViewModel(preview: true))
    }
}
