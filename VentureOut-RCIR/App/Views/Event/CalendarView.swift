//
//  CalendarView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/3/23.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    
    let interval: DateInterval
    @ObservedObject var eventStore: EventViewModel
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
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
            if let changedEvent = eventStore.changedEvent {
                uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
                eventStore.changedEvent = nil
            }
            if let movedEvent = eventStore.movedEvent {
                uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
                eventStore.movedEvent = nil
            }
        }
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        
        var parent: CalendarView
        @ObservedObject var eventStore: EventViewModel
       
       
        init(parent: CalendarView, eventStore: ObservedObject<EventViewModel>){
            self.parent = parent
            self._eventStore = eventStore
        }
        
        
        @MainActor
        func calendarView( _ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = eventStore.events.filter{ $0.date.startOfDay == dateComponents.date?.startOfDay}
            if foundEvents.isEmpty {return nil}
            if foundEvents.count > 1 {
                return .image(UIImage(systemName: "doc.on.doc.fill"),
                              color: .red, size: .large)
            }
            let singleEvent = foundEvents.first!
            return .customView {
                let icon = UILabel()
                icon.text = singleEvent.eventType.icon
                return icon
            }
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
        Coordinator(parent: self, eventStore: self._eventStore)
    }
   
}
