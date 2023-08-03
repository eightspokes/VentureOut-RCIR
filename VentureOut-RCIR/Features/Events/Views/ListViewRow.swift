import SwiftUI

struct ListViewRow: View {
    @State var event: Event
    @Binding var formType: EventFormType?
    @Binding var userType: ProfilePrivilege
    @EnvironmentObject var eventViewModel: EventViewModel
    @State var showEventRegistrationForm = false
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5 ) {
                HStack(spacing: 2) {
                    Text(event.eventType.icon)
                        .font(.system(size: 20))
                    Text(event.note)
                        .font(.title3)
                }
                Text(
                    event.date.formatted(date: .abbreviated,
                                         time: .shortened)
                ).font(.footnote)
                
                HStack(spacing: 20){
                    Text("Registered \(event.eventRegistrations.count)")
                    //.padding(.vertical)
                        .font(.body)
                }
                if userType == .admin{
                    HStack{
                        Button {
                            showEventRegistrationForm = true
                        } label: {
                            Text("Register ")
                                .font(.system(size: 15))
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            Spacer()
            if userType == .admin{
                Button {
                    formType = .update(event)
                } label: {
                    Text("Edit")
                        .font(.system(size: 15))
                }
                .buttonStyle(.bordered)
            } else {
                
                Button {
                } label: {
                    Text( "Sign up")
                        .font(.system(size: 15))
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showEventRegistrationForm){
            EventRegistrationForm(event: event)
        }
    }
    
}

struct ListViewRow_Previews: PreviewProvider {
    static let event = Event(eventType: .rowing, date: Date(), note: "Rowing event")
    static var previews: some View {
        ListViewRow(event: event, formType: .constant(.new), userType: .constant(.admin))
            .environmentObject(EventViewModel())
    }
}
