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
    @EnvironmentObject var slideInMenuService:  SlideInMenuService
    
    //Offset for Both Drag Gesture and Showing menu
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @State var sideBarWidth: CGFloat = 0
    @State var mainViewopacity = 1.0
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -500{
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
                                withAnimation(.easeIn(duration: 50)) {
                                    slideInMenuService.toggleMenu()
                                    
                                }
                                
   
                            }label:{
                                ProfilePictureView(image: "Paige")
                            }
                            Spacer()
                        }
                        .padding()
                        TabView{
                            
                            EventsCalendarView()
                                .offset(x: -sideBarWidth )
                              
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
                    
                    .opacity(mainViewopacity)
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
            .environmentObject(SlideInMenuService())
            .environmentObject(EventStore(preview: true))
        
            
    }
}
