//
//  VentureOut_RCIRApp.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/16/23.
//
import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct VentureOut_RCIRApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var eventStore = EventStore()
    var body: some Scene {
        WindowGroup {
            if authViewModel.userSession != nil {
                EventsCalendarView()
                    .environmentObject(authViewModel)
                    .environmentObject(eventStore)
            
            }else{
                LoginView()
                    .environmentObject(eventStore)
                    .environmentObject(authViewModel)
                   
            }
                
        }
    }
}
