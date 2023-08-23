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
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var slideInMenuService: SlideInMenuViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -50 {
                    withAnimation {
                        slideInMenuService.isPresented = false
                    }
                }
            }
        
        GeometryReader { geo in
            NavigationStack {
                ZStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Button {
                                withAnimation() {
                                    slideInMenuService.toggleMenu()
                                }
                            } label: {
                                ProfilePictureView(image: "Pat")
                            }
                            
                            Spacer()
                            Text("RCIR")
                                .font(.custom("Sacramento-Regular", size: 25, relativeTo: .title))
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        TabView {
                            
                            //TODO: Bug 
                            EventsInListView(preview: false)
                                .tabItem {
                                    Label("Event List", systemImage: "filemenu.and.selection")
                                }
                            EventsInCalendarView()
                                .tabItem {
                                    Label("Calendar", systemImage: "calendar")
                                }

                            RowersListView()
                                .tabItem {
                                    Label("Rowers", systemImage:  "figure.rower")
                                }
                            
                            CurrentWeatherView()
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
                    
                    if slideInMenuService.isPresented {
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
    }
}
