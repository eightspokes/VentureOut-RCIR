//
//  CalendarView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/3/23.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    
    let interval: DateInterval
    @ObservedObject var eventViweModel: EventViewModel
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    //@EnvironmentObject var authViewModel: AuthViewModel
    
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        DispatchQueue.main.async {
            if let changedEvent = eventViweModel.changedEvent {
                uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
                eventViweModel.changedEvent = nil
            }
            if let movedEvent = eventViweModel.movedEvent {
                uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
                eventViweModel.movedEvent = nil
            }
           
        }
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        var parent: CalendarView
        @ObservedObject var eventStore: EventViewModel
        @ObservedObject var authViewModel: AuthViewModel
       
       
        init(parent: CalendarView, eventStore: ObservedObject<EventViewModel>, authViewModel: ObservedObject<AuthViewModel>){
            self.parent = parent
            self._eventStore = eventStore
            self._authViewModel = authViewModel
        }
        
        
        @MainActor
        func calendarView( _ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = eventStore.events.filter{ $0.date.startOfDay == dateComponents.date?.startOfDay}
            
            if foundEvents.isEmpty {return nil}
            
            //If we are registered for events this day
            if isRegistered(dateComponents: dateComponents) {
                return .image(UIImage(systemName: "person.fill.checkmark"),
                              color: .green, size: .large)
            }

            
            //If we have several events in one day
            if foundEvents.count > 1 {
                return .image(UIImage(systemName: "doc.on.doc.fill"),
                              color: .blue, size: .large)
            }
            
            //If we have a signle event today
            let singleEvent = foundEvents.first!
            return .customView {
                
                let icon = UILabel()
                icon.text = singleEvent.eventType.icon
                return icon
            }

        }
        
        func isRegistered(dateComponents: DateComponents) -> Bool {
            let foundEvents = eventStore.events.filter{ $0.date.startOfDay == dateComponents.date?.startOfDay}
            guard let userRegistrations = authViewModel.currentUser?.eventRegistrations else{
                return false
            }
            
            for event in foundEvents{
                for userRegistration in userRegistrations {
                    if event.eventRegistrations.contains( userRegistration){
                        return true
                    }
                }
            }

            return false
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            guard let dateComponents else { return }
            let foundEvents = eventStore.events.filter{ $0.date.startOfDay == dateComponents.date?.startOfDay}
            if !foundEvents.isEmpty{
                parent.displayEvents.toggle()
            }
        }
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
     
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: self._eventViweModel, authViewModel: self._authViewModel)
    }
   
}
