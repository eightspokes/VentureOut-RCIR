//
//  Repository.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/26/23.
//

import Foundation
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventRepository: ObservableObject {
    
    // MARK: - Dependencies
    @Injected(\.firestore) var firestore
    @Injected(\.auth) var auth
    
    @Published var events = [Event]()
    /*
     Snapshot listener that subscribes to the Firestore collection that contains the events
     */
    private var listenerRegistration: ListenerRegistration?
    init() {
        subscribe()
    }
    deinit {
        unsubscribe()
    }
    private func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    func subscribe() {
        
        let query = firestore.collection(Event.collectionName)


        query
          .addSnapshotListener { [weak self] (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
              return
            }
              self?.events = documents.compactMap { queryDocumentSnapshot in
              do {
                return try queryDocumentSnapshot.data(as: Event.self)
              }
              catch {
                print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                return nil
              }
            }
          }
      }
    func addEvent(_ event: Event) throws {
        try firestore
            .collection(Event.collectionName)
            .addDocument(from: event)
    }
    func updateEvent(_ event: Event) throws {
        guard let documentId = event.id else{
            fatalError("Event \(event.note) has no document ID.")
            
        }
        try firestore
            .collection(Event.collectionName)
            .document(documentId)
            .setData(from: event, merge: true)
    }
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
    
    func updateEventRegistration(event: Event, user: User){
        let userID = user.id
        let eventID = event.id
        // Get a reference to the user document
        //We assume that user always have id's assigned by firebase
        let eventRef = firestore.collection("events").document(eventID!)
        let userRef = firestore.collection("users").document(userID)
        // Use the `setData` method to update the "peopleRegistered" field with the new string.
        eventRef.updateData(["peopleRegistered": FieldValue.arrayUnion([userID])]) { error in
            if let error = error {
                print("Error adding new person to peopleRegistered: \(error)")
            } else {
                //print("New person added to peopleRegistered successfully!")
            }
        }
        userRef.updateData(["eventsRegistered": FieldValue.arrayUnion([eventID!])]) { error in
            if let error = error {
                print("Error adding new person to peopleRegistered: \(error)")
            } else {
                //print("New person added to peopleRegistered successfully!")
            }
        }
        
    }
}
