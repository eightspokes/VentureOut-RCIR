//
//  AuthViewModel.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}



@MainActor
class AuthViewModel: ObservableObject {
    //It tells us if a user logged in (Login/Profile views )
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
 
    init() {
        //Store user information on the device
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: not able to sign in \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: failed to create user \(error.localizedDescription)")
        }
    }
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    func deleteAccount(){
        print("Deleting account")
    }
    func fetchUser() async  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("!!! \(String(describing: self.currentUser?.fullName))")
    }
    
}
