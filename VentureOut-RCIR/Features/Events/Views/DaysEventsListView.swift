//
//  DaysEventsListView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/3/23.
//

import SwiftUI

struct DaysEventsListView: View {
    @EnvironmentObject var eventStore: EventViewModel
   // @EnvironmentObject var authViewModel:  AuthViewModel
    
    @Binding var dateSelected: DateComponents?
    @State  var formType: EventFormType? //dual purpose view type
    @State  var privilage: ProfilePrivilege
   
    var body: some View {
        NavigationStack {
            Group {
                if let dateSelected {
                    let foundEvents = eventStore.events.filter { $0.date.startOfDay == dateSelected.date!.startOfDay }
                    List{
                        ForEach(foundEvents) { event in
                            ListViewRow(event: event, formType: $formType, userType: $privilage )
                                .swipeActions{
                                    Button(role: .destructive){
                                        eventStore.delete(event)
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

struct DaysEventsListView_Previews: PreviewProvider {
    static var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date())
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
    static var previews: some View {
        DaysEventsListView(dateSelected: .constant(dateComponents), privilage: ProfilePrivilege.admin)
            .environmentObject(EventViewModel(preview: true))
    }
}
