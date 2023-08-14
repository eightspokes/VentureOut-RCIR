import SwiftUI

struct ListViewRow: View {
    @State var event: Event
    
    @Binding var formType: EventFormType?
    @EnvironmentObject var eventViewModel: EventViewModel
    @EnvironmentObject var eventRegistrationViewModel: EventRegistrationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var showEventRegistrationForm = false
    @State private var showingYouAreAboutToSignOutAlert = false
    @State var showRegisterRowers  = false
    @State var showRowersRegistered = false
    var body: some View {
        
        
        HStack {
            VStack(alignment: .leading, spacing: 10 ) {
                HStack(spacing: 2) {
                    if let currentUser = authViewModel.currentUser {
                        if (eventRegistrationViewModel.isRegistered(currentUser, for: event) != nil){
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
                    event.date.formatted(date: .abbreviated,
                                         time: .shortened)
                ).font(.subheadline)
                
                
                      Button {
                          showRowersRegistered = true
                      } label: {
                          HStack() {
                              Image(systemName: "person")
                              Text("\(event.eventRegistrations.count) ")
                              Text(event.eventRegistrations.count == 1 ? "rower" : "rowers")
                          }
                          
                          .background(Color.clear) // Make sure the background is transparent
                      }
                    .buttonStyle(.bordered)
                  
            
                
                
                
                
                if authViewModel.currentUser != nil {
                    
                    if authViewModel.currentUser?.privilege == .admin{
                        
                        HStack{
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
            if let currentUser = authViewModel.currentUser{
                let eventRegistration = eventRegistrationViewModel.isRegistered(currentUser, for: event)
                Button {
                    if eventRegistration == nil {
                        showEventRegistrationForm = true
                    }else{
                        showingYouAreAboutToSignOutAlert = true
                    }
                    
                } label: {
                    
                    
                    Text(eventRegistration != nil ? "Sign out" : "Sign up" )
                        .font(.system(size: 15))
                }
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showEventRegistrationForm){
            EventRegistrationForm(event: event)
        }
        .sheet(isPresented: $showRegisterRowers){
            RegisterRowersView(preview: false, event: event)
        }
        .sheet(isPresented: $showRowersRegistered){
            RowersRegisteredForEventView(eventRegistrations: event.eventRegistrations)
        }
        .alert("Please confirm that you want to sign out from  \(event.note) on \(event.date.formatted())", isPresented: $showingYouAreAboutToSignOutAlert) {
            Button("OK", role: .cancel) {
                if let currentUser = authViewModel.currentUser{
                    
                    if let eventRegistration = eventRegistrationViewModel.isRegistered(currentUser, for: event){
                        eventRegistrationViewModel.delete(eventRegistration)
                    }
                   
                }
               
            }
        }
    }
    
}

struct ListViewRow_Previews: PreviewProvider {
    static let event = Event(eventType: .rowing, date: Date(), note: "Rowing event")
    static var previews: some View {
        ListViewRow(event: event, formType: .constant(.new))
            .environmentObject(EventViewModel(preview: true))
            .environmentObject(AuthViewModel(preview: true))
            .environmentObject(EventRegistrationViewModel(preview: true))
    }
}
