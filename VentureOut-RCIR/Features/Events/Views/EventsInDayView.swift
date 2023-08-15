//
//  DaysEventsListView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/3/23.
//

import SwiftUI

struct EventsInDayView: View {
    @EnvironmentObject var authViewModel:  AuthViewModel
    @EnvironmentObject var eventViewModel:  EventViewModel
    @EnvironmentObject var eventRegistrationViewModel:  EventRegistrationViewModel
    @Binding var dateSelected: DateComponents?
    @State private var formType: EventFormType? //dual purpose view type
    @State  var privilage: ProfilePrivilege
   
    var body: some View {
        NavigationStack {
            Group { 
                if let dateSelected {
                    let foundEvents = eventViewModel.events.filter { $0.date.startOfDay == dateSelected.date!.startOfDay }
                    List{
                        // Display events for date selected
                        ForEach(foundEvents) { event in
                            EventView(event: event, formType: $formType)
                                .swipeActions{
                                    Button(role: .destructive){
                                        eventRegistrationViewModel.deleteRegistrationsBy(event)
                                        eventViewModel.delete(event)
                                        
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .sheet(item: $formType) {$0}
                            
                        }

                    }
                }
            }
            .navigationTitle((dateSelected?.date?.formatted(date: .long, time: .omitted)) ?? "")
        }
    }
}

struct EventsInDayView_Previews: PreviewProvider {
    static var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date())
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
    static var previews: some View {
        EventsInDayView(dateSelected: .constant(dateComponents), privilage: ProfilePrivilege.admin)
           .environmentObject(EventViewModel(preview: true))
    }
}
