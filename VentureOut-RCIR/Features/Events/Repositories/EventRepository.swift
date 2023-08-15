//
//  EventRepository.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/26/23.
//

import Foundation
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift

/// A repository for managing events and event registrations.
public class EventRepository: ObservableObject {
    
    // MARK: - Dependencies
    
    @Injected(\.firestore) var firestore
    @Injected(\.auth) var auth
    
    @Published var events = [Event]()
    
    /*
     Snapshot listener that subscribes to the Firestore collection containing events.
     */
    private var listenerRegistration: ListenerRegistration?
    
    // MARK: - Lifecycle
    
    /*
     Initializes the event repository and subscribes to the Firestore collection for events.
     */
    init() {
        subscribe()
    }
    
    /*
     Unsubscribes from the Firestore collection when the repository is deinitialized.
     */
    deinit {
        unsubscribe()
    }
    
    private func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    // MARK: - Event Subscription
    
    /*
     Subscribes to the Firestore collection containing events and listens for updates.
     */
    func subscribe() {
        let query = firestore.collection(Event.collectionName)
        
        query.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self?.events = documents.compactMap { queryDocumentSnapshot in
                do {
                    return try queryDocumentSnapshot.data(as: Event.self)
                } catch {
                    print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    // MARK: - Event Management
    
    /*
     Adds an event to the Firestore collection.
     - Parameter event: The event to be added.
     */
    func addEvent(_ event: Event) throws {
        try firestore
            .collection(Event.collectionName)
            .addDocument(from: event)
    }
    
    /*
     Updates an existing event in the Firestore collection.
     - Parameter event: The event to be updated.
     */
    func updateEvent(_ event: Event) throws {
        guard let documentId = event.id else {
            fatalError("Event \(event.note) has no document ID.")
        }
        
        try firestore
            .collection(Event.collectionName)
            .document(documentId)
            .setData(from: event, merge: true)
    }
    
    /*
     Removes an event from the Firestore collection.
     - Parameter event: The event to be removed.
     - Returns: The removed event.
     */
    func removeEvent(_ event: Event) -> Event {
        guard let documentId = event.id else {
            fatalError("Event \(event.note) has no document ID.")
        }
        
        firestore
            .collection(Event.collectionName)
            .document(documentId)
            .delete()
        
        return event
    }
    
    // MARK: - Event Registration
    
    /*
     Updates event registration for a user and an event.
     - Parameters:
        - event: The event to be registered for.
        - user: The user registering for the event.
     */
    func updateEventRegistration(event: Event, user: User) {
        let userID = user.id
        let eventID = event.id
        
        // Get references to the event and user documents
        let eventRef = firestore.collection("events").document(eventID!)
        let userRef = firestore.collection("users").document(userID)
        
        // Update the "peopleRegistered" field for the event
        eventRef.updateData(["peopleRegistered": FieldValue.arrayUnion([userID])]) { error in
            if let error = error {
                print("Error adding new person to peopleRegistered: \(error)")
            } else {
                //print("New person added to peopleRegistered successfully!")
            }
        }
        
        // Update the "eventsRegistered" field for the user
        userRef.updateData(["eventsRegistered": FieldValue.arrayUnion([eventID!])]) { error in
            if let error = error {
                print("Error adding new person to eventsRegistered: \(error)")
            } else {
                //print("Event added to eventsRegistered successfully!")
            }
        }
    }
}
