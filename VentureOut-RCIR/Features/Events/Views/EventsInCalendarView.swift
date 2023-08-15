import SwiftUI

/// A view for displaying events on a calendar.
struct EventsInCalendarView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    
    @State private var dateSelected: DateComponents?
    @State private var displayEvents: Bool = false
    @State private var formType: EventFormType?
    
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                Spacer()
                Text("Events")
                    .font(.title)
                Spacer()
                Button {
                    formType = .new
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            CalendarView(
                interval: DateInterval(start: .distantPast, end: .distantFuture),
                eventViweModel: eventViewModel,
                authViewModel: authViewModel,
                eventRegistrationViewModel: eventRegistrationViewModel,
                dateSelected: $dateSelected,
                displayEvents: $displayEvents
            )
            
            Image("rowers")
                .resizable()
                .scaledToFit()
                .frame(width: 170)
                .offset(y: -20)
        }
        .sheet(item: $formType) { $0 }
        .sheet(isPresented: $displayEvents) {
            EventsInDayView(dateSelected: $dateSelected, privilage: ProfilePrivilege.admin)
                .presentationDetents([.medium, .large])
        }
    }
}

struct EventsInCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsInCalendarView()
            .environmentObject(EventViewModel(preview: true))
            .environmentObject(AuthViewModel(preview: true))
            .environmentObject(EventRegistrationViewModel(preview: true))
    }
}
