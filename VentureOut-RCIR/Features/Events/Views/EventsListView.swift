
import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var eventViewModel: EventViewModel
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
                        // showNewEventView = true
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                    
                    
                    
                }
                
                List {
                    
                    ForEach(eventViewModel.events.sorted {$0.date < $1.date }) { event in
                        ListViewRow(event: event, formType: $formType, userType: $userType)
                            .swipeActions {
                                Button(role: .destructive) {
                                    eventViewModel.delete(event)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
                .foregroundColor(.indigo)
                .font(.title2)
                
                .sheet(item: $formType){ formType in
                    formType
                    
                }
            }
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
           .environmentObject(EventViewModel(preview: true))
    }
}
