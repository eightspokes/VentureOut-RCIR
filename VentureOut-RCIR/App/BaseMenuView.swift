//
//  BaseMenuView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/10/23.
//

import SwiftUI

struct BaseMenuView: View {
    @State var showMenu: Bool = false
    @State var currentTab: String = "Home"
    @EnvironmentObject var authViewModel:  AuthViewModel
    @EnvironmentObject var slideInMenuService:  SlideInMenuViewModel

    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -50{
                   withAnimation {
                        slideInMenuService.isPresented = false
                   }
                }
            }
        
       GeometryReader { geo in
           
            NavigationStack {
                
                ZStack(alignment: .leading) {
                    VStack{
                        HStack{
                            Button{
                                withAnimation() {
                                    slideInMenuService.toggleMenu()
                                }
                            }label:{
                                ProfilePictureView(image: "Paige")
                            }
                            
                            Spacer()
                            Text("Venture Out")
                                .font(.custom("Sacramento-Regular", size: 25, relativeTo: .title))
                            
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        TabView{
                            EventsListView()
                                .tabItem {
                                    Label("Event List", systemImage: "filemenu.and.selection")
                                }
                            
                            
                            EventsCalendarView()
                            
                                .tabItem {
                                    Label("Calendar", systemImage: "calendar")
                                }
                            Text("Rowing now")
                                .tabItem {
                                    Label("Rowing today", systemImage:  "figure.rower")
                                }
                            
                            Text("Weather")
                                .tabItem {
                                    Label("Weather", systemImage: "cloud.sun.rain")
                            }
                            Text("Map")
                                .tabItem {
                                    Label("Map", systemImage: "mappin.and.ellipse")
                                }
                        }
                        .disabled(slideInMenuService.isPresented)
                    }
                    
                    if slideInMenuService.isPresented{
                        SlideInMenuView()
                            .transition(.move(edge: .leading))
                            
                    }
                    
                   
                    
                }
                .gesture(drag)
               
            }
        }
    }
}

struct BaseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        BaseMenuView()
            .environmentObject(AuthViewModel(preview: true))
            .environmentObject(SlideInMenuViewModel())
            .environmentObject(EventViewModel(preview: true))
        
            
    }
}
