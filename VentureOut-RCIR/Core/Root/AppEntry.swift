//
//  VentureOut_RCIRApp.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/16/23.
//
import FirebaseCore
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
    //State object for our session service
    //@StateObject var sessionService = SessionServiceImpl()
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
//            NavigationView{
//                switch sessionService.state{
//                case .loggedIn:
//                    HomeView()
//                        .environmentObject(sessionService)
//                case .loggedOut:
//                    LoginView()
//                }
//
//            }
        }
    }
}
