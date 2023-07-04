
import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var myEvents: EventStore
    @State private var formType: EventFormType?
    @State private var userType: ProfilePrivilege = .admin
    let gradient = LinearGradient(colors: [Color.orange,Color.green],
                                      startPoint: .top, endPoint: .bottom)

    init() {
     
               
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]


    }
    
    var body: some View {
        NavigationStack {
            ZStack{
              DynamicBackgroundView()
                
                VStack(spacing: 0){
                    
                    
                   
                   
//                    Picker( selection: $userType, label: Text("")) {
//                        ForEach(Array(ProfilePrivilege.allCases), id: \.self) { privilege in
//
//                            let menuText = privilege.stringValue()
//                            Text("\(menuText)")
//                                .tag(privilege)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .padding(.horizontal)
                    
                    
                    List {
                        
                        ForEach(myEvents.events.sorted {$0.date < $1.date }) { event in
                            ListViewRow(event: event, formType: $formType, userType: $userType)
                                .swipeActions {
                                Button(role: .destructive) {
                                    myEvents.delete(event)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    .padding(.top)
                 //   .scrollContentBackground(.hidden)
                 
                }
            }
           

            
            .navigationTitle("Events")
          
            
            .foregroundColor(.indigo)
            .font(.title2)
          
            .sheet(item: $formType) { formType in
                formType
                
            }
            .toolbar {
                    if userType == .admin {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            formType = .new
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                        .padding(.top , 80)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("white-rowers")
                        .resizable()
                        .frame(width: 170,height: 40 )
                        .padding(.top)
                }
            }
            
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            .environmentObject(EventStore(preview: true))
    }
}
