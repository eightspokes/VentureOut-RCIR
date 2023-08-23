//
//  VentureOut_RCIRApp.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/16/23.
//
import Firebase
import SwiftUI
import UserNotifications
import FirebaseMessaging



class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in})
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
        
    }
    @main
    struct VentureOut_RCIRApp: App {
        
        
        @StateObject var authViewModel = AuthViewModel()
        @StateObject var eventViewMedel = EventViewModel()
        @StateObject var eventRegistrationViewModel = EventRegistrationViewModel()
        @StateObject var slideInMenuService = SlideInMenuViewModel()
        let backgroundColor = Color(red: 0.1714548767, green: 0.5494146943, blue: 0.9782393575, opacity: 1.0)
        
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        var body: some Scene {
            WindowGroup {
                Group{
                    if authViewModel.userSession != nil {
                        BaseMenuView()
                            .background(backgroundColor)
                    }else{
                        LoginView()
                    }
                }
                .environmentObject(authViewModel)
                .environmentObject(eventViewMedel)
                .environmentObject(slideInMenuService)
                .environmentObject(eventRegistrationViewModel)
            }
        }
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging (_messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        let deviceToken: [String: String] = ["token": fcmToken ?? ""]
        print( "Device token: ", deviceToken) // for testign
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping( UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey]{
            print("Message ID :\(messageID)")
        }
        print(userInfo)
        
        //change this to your preferred presentation options
        completionHandler([[.badge,.badge,.sound]])
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationWithDeviceToken deviceToken: Data){
        
    }
}
