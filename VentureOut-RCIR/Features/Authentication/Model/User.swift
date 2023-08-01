//
//  User.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let fullName: String
    let email: String
    var privilege: ProfilePrivilege = ProfilePrivilege.admin
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

enum ProfilePrivilege: String, CaseIterable, Codable {
    
    case rower, admin
    
    func stringValue() -> String {
        switch (self){
            
        case .rower:
            return "rower"
        case .admin:
            return "admin"

        }
    }
}
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "Roman Kozulia", email: "romanmuni8@gmail.com", privilege: .admin)
}
