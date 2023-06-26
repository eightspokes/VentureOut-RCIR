//
//  AuthViewModel.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    //It tells us if a user logged in (Login/Profile views )
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
 
    init(){
        
    }
    
    func signIn( withEmail email: String, password: String) async throws {
        print("Signing in")
    }
    
    func createUser(withEmail email: String, password: String) async throws{
        print("Created as user ")
    }
    func signOut(){
        print("Signing out ")
    }
    func deleteAccount(){
        print("Deleting account")
    }
    func fetchUser() async {
        print("Fetching user")
    }
    
}
