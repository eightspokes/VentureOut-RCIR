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
import Factory




protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}
// ... (Previous imports and protocols remain the same)

/// ViewModel for handling authentication-related logic.
@MainActor
class AuthViewModel: ObservableObject {
    
    // MARK: Injected Properties
    
    @Injected(\.auth) private var auth
    @Injected(\.firestore) private var firestore
    
    // MARK: Published Properties
    
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    @Published var preview: Bool
    
    // MARK: Initialization
    
    /// Initializes the authentication view model.
    /// - Parameter preview: A boolean value indicating whether the preview mode is active.
    init(preview: Bool = false ) {
        self.preview = preview
        if preview {
            self.currentUser = User(id: "id", fullName: "Tailor Swift", email: "tailorSwift@gmail.com")
        } else {
            self.userSession = auth.currentUser
            Task {
                await fetchUser()
            }
        }
    }
    
    // MARK: Authentication Methods
    
    /// Attempts to sign in the user using their email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: not able to sign in \(error.localizedDescription)")
        }
    }
    
    /// Creates a new user account and adds them to the Firestore database.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - fullName: The user's full name.
    func addNewRower(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await firestore.collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: failed to create user \(error.localizedDescription)")
        }
    }

    /// Creates a new user account, signs them in, and adds them to the Firestore database.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - fullName: The user's full name.
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await firestore.collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: failed to create user \(error.localizedDescription)")
        }
    }
    
    /// Signs the current user out.
    func signOut() {
        do {
            try auth.signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    /// Deletes the current user's account.
    func deleteAccount() {
        print("Deleting account")
    }
    
    /// Fetches the current user's data from Firestore.
    func fetchUser() async {
        guard let uid = auth.currentUser?.uid else { return }
        guard let snapshot = try? await firestore.collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    /// Fetches all users from the Firestore database.
    /// - Parameter completion: A closure that is called with an array of `User` objects.
    func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        firestore.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error fetching all users - \(error.localizedDescription)")
                completion([])
                return
            }
            
            var users: [User] = []
            for document in snapshot?.documents ?? [] {
                if let user = try? document.data(as: User.self) {
                    users.append(user)
                }
            }
            
            completion(users)
        }
    }
}
