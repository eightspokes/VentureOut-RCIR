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
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var eventStore = EventStore()
    @StateObject var slideInMenuService = SlideInMenuService()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 
    
    var body: some Scene {
        WindowGroup {
            Group{
                if authViewModel.userSession != nil {
                    BaseMenuView()
                }else{
                    LoginView()
                }
            }
            .environmentObject(authViewModel)
            .environmentObject(eventStore)
            .environmentObject(slideInMenuService)
            
        } 
    }
}
