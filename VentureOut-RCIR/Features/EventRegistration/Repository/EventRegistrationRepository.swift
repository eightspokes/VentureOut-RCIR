//
//  EventRegistrationRepository.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/2/23.
//


import Foundation
import Factory
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventRegistrationRepository: ObservableObject {
    
    // MARK: - Dependencies
    @Injected(\.firestore) var firestore
    @Injected(\.auth) var auth
    
    @Published var eventsRegistrations = [EventRegistration]()
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
    func subscribe(){
        if listenerRegistration == nil {
            /*
             Set up a Firestore query for fetching all events from the events collection.
             */
            let query = firestore.collection(EventRegistration.collectionName)
            self.listenerRegistration = query as? any ListenerRegistration
            /*
             This listener will be called whenever the data returned by the query changes: e.g. when a new document is added, data in a document is changed, or a document is deleted.
             */
            query
                .addSnapshotListener { [weak self] (querySnapshot, error) in
                    //Make sure query is not empty
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                
                    self?.eventsRegistrations = documents.compactMap { queryDocumentSnapshot in
                        do {
                            let result = try queryDocumentSnapshot.data(as: EventRegistration.self)
                           // print("!!!!!!!!!!!!!! Subscribed After map \(self!.eventsRegistrations.count)")
                            return result
                            
                        }
                        catch {
                            print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                            return nil
                        }
                        
                    }
                }
        }
    }
    func addEventRegistration(_ eventRegistration: EventRegistration) throws {
          
          let collectionRef = firestore.collection(EventRegistration.collectionName)
          
          // Add the document to Firestore
          var newEventRegistrationRef: DocumentReference?
          
          try newEventRegistrationRef = collectionRef.addDocument(from: eventRegistration) { [self] error in
              if let error = error {
                  print("Error adding document: \(error)")
              } else {
                  // The document has been added successfully
                  // The ID of the newly created document will be available in eventRegistration.id
                  // print("This is my new event ref\(newEventRegistrationRef?.documentID ?? "No Event ref")")
                  let userRef = firestore.collection(User.collectionName).document(eventRegistration.userId)
                  let eventRef = firestore.collection(Event.collectionName).document(eventRegistration.eventId)
                  
                  print("\(userRef.documentID )")
                  print("\(eventRef.documentID)")
                  
                  guard let newEventRegistrationId = newEventRegistrationRef else{
                      print(" Event registration failed - no event id ")
                      return
                  }
                  userRef.updateData(["eventRegistrations": FieldValue.arrayUnion([newEventRegistrationId.documentID])]) { error in
                      if let error = error {
                          print("Error adding new event registration  to to User's eventRegistrations: \(error)")
                      } else {
                          print("New pevent registration was added successfully to User's  eventRegistration!")
                      }
                  }
                  eventRef.updateData(["eventRegistrations": FieldValue.arrayUnion([newEventRegistrationId.documentID])]) { error in
                      if let error = error {
                          print("Error adding new event registration to to Event's eventRegistrations: \(error)")
                      } else {
                          print("New pevent registration was added successfully to Event's  eventRegistration!")
                      }
                  }
              }
          }
      }
    func updateEventRegistration(_ eventRegistration: EventRegistration) throws {
        guard let documentId = eventRegistration.id else{
            fatalError("Event \(eventRegistration.note) has no document ID.")
            
        }
        try firestore
            .collection(EventRegistration.collectionName)
            .document(documentId)
            .setData(from: eventRegistration, merge: true)
    }
    func removeEventRegistration(_ eventRegistration: EventRegistration){
        guard let eventRegistrationId = eventRegistration.id else {
            fatalError("Event \(eventRegistration.note) has no document ID.")
        }
        
        firestore
            .collection(EventRegistration.collectionName)
            .document(eventRegistrationId)
            .delete()
        //Remove eventRegistration from User
        removeElementFromEventRegistrations(collection: User.collectionName, eventDocumentID: eventRegistration.user.id, elementToRemove: eventRegistrationId)
        //Remove eventRegistration from Event
        removeElementFromEventRegistrations(collection: Event.collectionName, eventDocumentID: eventRegistration.eventId, elementToRemove: eventRegistrationId)
    }
    //Events and Users have eventreGistrations array, when an eventRegistration is remove, the correspondent
    //arrays need to be updated.
    
    
    func removeEventRegistrationBy(_ event: Event) {
        let eventRegistrationCollection = firestore.collection(EventRegistration.collectionName)
        
        eventRegistrationCollection
            .whereField("eventId", isEqualTo: event.id!)
            .getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                } else {
                    for document in querySnapshot!.documents {
                        // Remove registration itself
                        document.reference.delete()
                        // Remove eventRegistration from User
                        self.removeElementFromEventRegistrations(collection: User.collectionName, eventDocumentID: document["userId"] as? String ?? "", elementToRemove: document.documentID)
                    }
                    print("Documents with eventId: \(String(describing: event.id)) deleted successfully.")
                }
            })
    }
    
    private func removeElementFromEventRegistrations(collection: String, eventDocumentID: String, elementToRemove: String) {
        
        let eventRef = firestore.collection(collection).document(eventDocumentID)
        
        eventRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("Document not found")
                return
            }
            
            var data = document.data() ?? [:]
            
            if var eventRegistrations = data["eventRegistrations"] as? [String],
               let indexToRemove = eventRegistrations.firstIndex(of: elementToRemove) {
                
                eventRegistrations.remove(at: indexToRemove)
                data["eventRegistrations"] = eventRegistrations
                
                eventRef.setData(data) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Element removed successfully")
                    }
                }
            } else {
                print("Element not found in the array")
            }
        }
    }
}
