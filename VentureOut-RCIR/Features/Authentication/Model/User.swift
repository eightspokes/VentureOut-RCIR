//
//  User.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import Foundation

/// Represents a user with various attributes.
struct User: Identifiable, Codable{
    let id: String
    let fullName: String
    let email: String
    var privileges: [ProfilePrivilege] =  [.visitor]
    var eventRegistrations = [String]()
    var profilePrivilegesAsString: String {
        var profilePrivileges = ""
        for u in privileges {
                profilePrivileges.append(u.stringValue())
                profilePrivileges.append("/")
            }
        
        return profilePrivileges
    }
    
    /// Computes the initials of the user's full name.
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
/*
 Visitor - has not been granted privilage to register for events, not verified visitor
 Rower - can register for rowing
 Admin - can see information about other rowers.
 Registrar - can register other rowers / can remove other rowers, received notifications about people registered.
 Launch - person who can assign themself as a launcher, who receive notification about other people registered as launchers
 Volunteers  - can register as volunteer.
 */
enum ProfilePrivilege: String, CaseIterable, Codable {
    case  admin, launch, registrar, visitor, volunteer
    func stringValue() -> String {
        return self.rawValue
    }
}
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "Roman Kozulia", email: "romanmuni8@gmail.com")
}
extension User {
  static let collectionName = "users"
}
