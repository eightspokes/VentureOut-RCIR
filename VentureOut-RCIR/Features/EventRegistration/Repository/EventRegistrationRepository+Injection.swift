//
//  EventRegistrationRepository+Injection.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/2/23.
//

import Foundation

import Foundation
import Factory

extension Container {
    public var eventRegistrationRepository: Factory<EventRegistrationRepository>{
        Factory(self){
            EventRegistrationRepository()
        }.singleton
    }
}
