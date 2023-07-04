//
//  EventCalendarView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/1/23.
//

import SwiftUI

struct EventsCalendarView: View {
    @EnvironmentObject var eventStore: EventStore
    @EnvironmentObject var slideInMenuService: SlideInMenuService
    @State private var dateSelected: DateComponents?
    @State private var displayEvents: Bool = false
    @State private var formType: EventFormType?
    
    var body: some View {
        NavigationStack{
            ScrollView{
                CalendarView(interval: DateInterval(start:.distantPast, end: .distantFuture), eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents)
                    .environmentObject(eventStore)
                
                Image("rowers")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                
            }
            .toolbar{
          
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        slideInMenuService.toggleMenu()
                        print("\( slideInMenuService.isPresented)")
                        
                    } label: {
                        Image(systemName: "filemenu.and.selection")
                            .font(.system(size: 18))
                    }
                    
                    
//                    .onTapGesture {
//                        if slideInMenuService.isPresented {
//                            slideInMenuService.toggleMenu()
//                        }
//                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        formType = .new
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $formType){ $0 }
            .sheet(isPresented: $displayEvents){
                DaysEventsListView(dateSelected: $dateSelected, privilage: ProfilePrivilege.admin)
                    .presentationDetents([.medium,.large])
            }
            .navigationTitle("Events")
            
        }
    }
}

struct EventCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView()
            .environmentObject(EventStore(preview: true))
    }
}
