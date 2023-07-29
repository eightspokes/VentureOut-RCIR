//
//  Repository.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public class EventRepository: ObservableObject {
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
    func subscribe(){
        
        if listenerRegistration == nil {
            
            /*
             Set up a Firestore query for fetching all events from the events collection.
             */
            let query = Firestore.firestore().collection(Event.collectionName)
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
                    print("Mapping \(documents.count) documents")
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
        
    }
    
    func addEvent(_ event: Event) throws {
        print("1******Called add event from reminder repository")
        try Firestore
             .firestore()
             .collection(Event.collectionName)
             .addDocument(from: event)
        print("2******Event should have been added")
    }
    func updateEvent(_ event: Event) throws {
        print("***** This is my event I am passing in \(event.note) \(event.id ?? "No Id")")
        guard let documentId = event.id else{
            fatalError("Event \(event.note) has no document ID.")
        }
        try Firestore
             .firestore()
             .collection(Event.collectionName)
             .document(documentId)
             .setData(from: event, merge: true)
    }
    func removeEvent(_ event: Event){
        guard let documentId = event.id else {
            fatalError("Event \(event.note) has no document ID.")
        }
            Firestore
              .firestore()
              .collection(Event.collectionName)
              .document(documentId)
              .delete()
    } 
}
