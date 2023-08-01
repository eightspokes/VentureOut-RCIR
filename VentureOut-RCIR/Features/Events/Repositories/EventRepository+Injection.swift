//
//  ReminderRepository+Injection.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import Foundation
import Factory

extension Container {
    public var eventRepository: Factory<EventRepository>{
        Factory(self){
            EventRepository()
        }.singleton
    }
}
