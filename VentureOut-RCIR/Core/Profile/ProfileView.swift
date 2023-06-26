//
//  ProfileView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel:  AuthViewModel
    var body: some View {
        List{
            Section{
                
                HStack {
                    Text(User.MOCK_USER.initials)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                    .clipShape(Circle())
                    VStack(alignment: .leading){
                        Text(User.MOCK_USER.fullName)
                            .bold()
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                    .padding(.leading)
                }
            }
            
            Section("General"){
                HStack{
                    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                    Text("1.1.0")
                }
                
            }
            
            
            Section("Account"){
                Button{
                    print("Sign out")
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign up", tintColor: .red)
                }
                Button{
                    print("Detlete account")
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Sign up", tintColor: .red)
                }
                
               
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
