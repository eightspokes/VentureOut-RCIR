//
//  EventRegistration.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/2/23.
//
import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase
import Foundation
/*
 The @DocumentID property wrapper will populate its property with the document ID when the document is read from Firestore.
 */


struct EventRegistration: Codable, Identifiable{
    
    @DocumentID var id: String?
    let user: User
    var eventId: String
    var eventType: Event.EventType
    var date: Date
    var note: String
    
    let userId: String
    let fullName: String
    let email: String
    var noteToAdmin: String
    
    
    init(id: String? = nil,
         user: User,
         
         eventId: String,
         eventType: Event.EventType,
         date: Date,
         note: String,
        
         userId: String,
         fullName: String,
         email: String,
         noteToAdmin: String) {
        
        self.id = id
        self.user = user
      
        
        self.eventId = eventId
        self.eventType = eventType
        self.date = date
        self.note = note
        
        
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.noteToAdmin = noteToAdmin
    }
    static var sampleEventRegistration =  [
        EventRegistration(id: "", user: User.MOCK_USER, eventId: "", eventType: .rowing,
                          date: Date(),
                          note: "Some note ",
                          userId: "John Doe",
                          fullName: "john.doe@example.com",
                          email: "Please approve my registration.", noteToAdmin: "Hello"),
        EventRegistration(id: "",user: User.MOCK_USER,  eventId: "", eventType: .rowing,
                          date: Date(),
                          note: "Some note ",
                          userId: "John Doe",
                          fullName: "john.doe@example.com",
                          email: "Please approve my registration.", noteToAdmin: "Hello")
        ]
}
//To be used by Repository to specify collection Name in Firebase
extension EventRegistration {
  static let collectionName = "eventRegistration"
}
