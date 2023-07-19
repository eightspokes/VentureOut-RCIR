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

            
            ScrollView{
                HStack(spacing: 0){
                    Spacer()
                    Text("Events")
                        .font(.title)
                    Spacer()
                    Button{
                        formType = .new
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                CalendarView(interval: DateInterval(start:.distantPast, end: .distantFuture), eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents)
                    .environmentObject(eventStore)
                    
                
                Image("rowers")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170)
                    .offset(y: -20)
                
                
            }
            .sheet(item: $formType){ $0 }
            .sheet(isPresented: $displayEvents){
                DaysEventsListView(dateSelected: $dateSelected, privilage: ProfilePrivilege.admin)
                    .presentationDetents([.medium,.large])
            }
           
            
        }
    
}

struct EventCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView()
            .environmentObject(EventStore(preview: true))
    }
}
