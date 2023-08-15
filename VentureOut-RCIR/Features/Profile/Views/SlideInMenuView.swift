//
//  SlideInMenuView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/4/23.
//

import SwiftUI

struct SlideInMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var slideInMenuService: SlideInMenuViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        slideInMenuService.toggleMenu()
                    } label: {
                        ProfilePictureView(image: "Pat")
                            .padding()
                    }
                    Spacer()
                }
                PersonalInfo(image: "Roman", userName: authViewModel.currentUser?.fullName ?? "", email: authViewModel.currentUser?.email ?? "", privilege: authViewModel.currentUser?.privilege.stringValue() ?? "")
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        TabButton(title: "Profile", image: "person") {
                            // Action for "Profile" tab
                        }
                        TabButton(title: "Terms and Conditions", image: "list.bullet.clipboard") {
                            // Action for "Terms and Conditions" tab
                        }
                        TabButton(title: "Logout", image: "rectangle.portrait.and.arrow.right") {
                            print("Log out called")
                            authViewModel.signOut()
                        }
                        Divider()
                        HStack {
                            TabButton(title: "Version", image: "gear") {
                                print("Gear clicked")
                                authViewModel.deleteAccount()
                                authViewModel.signOut()
                            }
                            Text("1.0.0")
                            Spacer()
                        }
                        TabButton(title: "Delete account", image: "xmark.circle") {
                            print("Delete account called")
                            authViewModel.deleteAccount()
                            authViewModel.signOut()
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            .frame(width: geo.size.width * 0.7)
            .frame(maxHeight: .infinity)
            .background(
                Color(UIColor.systemGray6)
                    .ignoresSafeArea(.container, edges: .vertical)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    func PersonalInfo(image: String, userName: String, email: String, privilege: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(userName)
                    .font(.title2.bold())
                Text(email)
                    .font(.callout)
                Text(privilege)
                    .font(.caption)
            }
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func TabButton(title: String, image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 22, height: 22)
                Text(title)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SlideInMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideInMenuView()
            .environmentObject(AuthViewModel(preview: true))
    }
}
