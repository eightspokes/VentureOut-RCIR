
import SwiftUI

struct EventsInListView: View {
    /// A flag indicating whether this view is in preview mode.
    var preview: Bool
    
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    
    @State private var formType: EventFormType?
    @State private var userType: ProfilePrivilege = .admin
    @State private var showNewEventView = false
   
    var body: some View {
        NavigationStack {
            VStack{
                
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
                            .padding(.trailing)
                    }
                }
                List {
                    ForEach(preview ? Event.sampleEvents : eventViewModel.events.sorted {$0.date < $1.date }) { event in
                       
                        EventView(event: event, formType: preview ? .constant(.new) : $formType)
                            .swipeActions {
                                Button(role: .destructive) {
                                    eventViewModel.delete(event)
                                    eventRegistrationViewModel.deleteRegistrationsBy(event)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
                
                .sheet(item: $formType){ formType in
                    formType

                }
            }
        }
    }
}
struct EventsInListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsInListView(preview: true)
            .environmentObject(EventViewModel(preview: true))
            .environmentObject(EventRegistrationViewModel(preview: true))
    }
}
