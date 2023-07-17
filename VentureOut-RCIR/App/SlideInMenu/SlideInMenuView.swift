//
//  SlideInMenuView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/4/23.
//

import SwiftUI

struct SlideInMenuView: View {
    @EnvironmentObject var authViewModel:  AuthViewModel
    @EnvironmentObject var slideInMenuService: SlideInMenuService
    var body: some View {

        GeometryReader { geo in
            
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Button{
                        withAnimation(.easeIn(duration: 3.5)) {
                            slideInMenuService.toggleMenu()
                        }
                        
                        
                        
                    }label:{
                        ProfilePictureView(image: "Paige")
                            .padding()
                    }
                    Spacer()
                }
                PersonalInfo(image: "Roman", userName: authViewModel.currentUser?.fullName ?? "", email: authViewModel.currentUser?.email ?? "")
                
                ScrollView(.vertical, showsIndicators: true){
                    VStack(spacing: 20){
                       // TabButton(title: "Calendar", image: "calendar")
                       // TabButton(title: "Weather", image: "sun.haze")
                       // TabButton(title: "Map", image: "mappin.and.ellipse")
                        TabButton(title: "Profile", image: "person")
                        
                        TabButton(title: "Terms and Conditions ", image: "list.bullet.clipboard")
                        
                        Divider()
                        TabButton(title: "Logout", image: "rectangle.portrait.and.arrow.right")
                    }
                    .padding()
                    .padding(.leading)
                    .padding(.top,25)
                }
                
                    Spacer()
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
}

@ViewBuilder
func PersonalInfo(image: String, userName: String, email: String) -> some View{
    HStack {
        VStack(alignment: .leading, spacing: 5){
            Text(userName)
                .font(.title2.bold())
            Text(email)
                .font(.callout)
        }
        Spacer()
    }
    .padding()
}



@ViewBuilder
func TabButton(title: String, image: String) -> some View {
    Button{
        
    } label: {
        HStack(spacing: 14){
           
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

struct SlideInMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideInMenuView()
            .environmentObject(AuthViewModel(preview: true))
            
    }
}

