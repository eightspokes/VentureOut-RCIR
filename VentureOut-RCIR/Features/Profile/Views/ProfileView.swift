//
//  ProfileView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text(authViewModel.currentUser?.initials ?? "N/A")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        HStack {
                            Text(authViewModel.currentUser?.fullName ?? "Name not available")
                                .bold()
                            if let privilege = authViewModel.currentUser?.privilege, privilege == .admin {
                                Text("(admin)")
                            }
                        }
                        Text(authViewModel.currentUser?.email ?? "Email not available")
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                    .padding(.leading)
                }
            }
            
            Section(header: Text("General")) {
                HStack {
                    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                    Text("1.1.0")
                }
            }
            
            Section(header: Text("Account")) {
                Button {
                    authViewModel.signOut()
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign out", tintColor: .red)
                }
                
                Button {
                    // Add functionality for deleting account
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Delete account", tintColor: .red)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
