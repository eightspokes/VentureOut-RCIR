import SwiftUI

/// A view representing a single row in the list view.
struct EventView: View {
    
    // This event, how do I make it persistant.
    var event: Event
    
    @Binding var formType: EventFormType?
    
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var showEventRegistrationForm = false
    @State private var showingYouAreAboutToSignOutAlert = false
    @State var showRegisterRowers = false
    @State var showRowersRegistered = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10 ) {
                HStack(spacing: 2) {
                    if let currentUser = authViewModel.currentUser {
                        if let _ = eventRegistrationViewModel.isRegistered(currentUser, for: event) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    
                    Text(event.eventType.icon)
                        .font(.system(size: 30))
                    Text(event.note)
                        .font(.title2)
                }
                Text(
                    event.date.formatted(date: .abbreviated, time: .shortened)
                ).font(.subheadline)
                
                Button {
                    showRowersRegistered = true
                } label: {
                    HStack() {
                        Image(systemName: "person")
                        if let event = event, let id = event.id {
                            if let eventByID = eventViewModel.getEventByID(id) {
                                let registrationCount = eventByID.eventRegistrations.count
                                
                                HStack {
                                    Text("\(registrationCount)")
                                   
                                    Text(registrationCount == 1 ? "rower" : "rowers")
                                }
                            }
                        }
                        
                    }
                    .background(Color.clear)
                }
                .buttonStyle(.bordered)
                
                if authViewModel.currentUser != nil {
                    if authViewModel.currentUser?.privilege == .admin {
                        HStack {
                            Button {
                                showRegisterRowers = true
                            } label: {
                                Text("Register Rowers")
                                    .font(.system(size: 15))
                            }
                            .buttonStyle(.bordered)
                            
                            Button {
                                formType = .update(event)
                            } label: {
                                Text("Edit Event")
                                    .font(.system(size: 15))
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            
            Spacer()
            
            if let currentUser = authViewModel.currentUser {
                let eventRegistration = eventRegistrationViewModel.isRegistered(currentUser, for: event)
                Button {
                    if eventRegistration == nil {
                        showEventRegistrationForm = true
                    } else {
                        showingYouAreAboutToSignOutAlert = true
                    }
                } label: {
                    Text(eventRegistration != nil ? "Sign out" : "Sign up" )
                        .font(.system(size: 15))
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showEventRegistrationForm) {
            EventRegistrationForm(event: event)
        }
        .sheet(isPresented: $showRegisterRowers) {
            RegisterRowersView(preview: false, event: event)
        }
        .sheet(isPresented: $showRowersRegistered) {
            RowersRegisteredForEventView(event: event)
        }
        .alert(
            "Please confirm that you want to sign out from \(event.note) on \(event.date.formatted())",
            isPresented: $showingYouAreAboutToSignOutAlert
        ) {
            Button("OK", role: .cancel) {
                if let currentUser = authViewModel.currentUser {
                    if let eventRegistration = eventRegistrationViewModel.isRegistered(currentUser, for: event) {
                        eventRegistrationViewModel.delete(eventRegistration)
                    }
                }
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static let event = Event(eventType: .rowing, date: Date(), note: "Rowing event")
    
    static var previews: some View {
        EventView(event: event, formType: .constant(.new))
            .environmentObject(EventViewModel(preview: true))
            .environmentObject(AuthViewModel(preview: true))
            .environmentObject(EventRegistrationViewModel(preview: true))
    }
}
