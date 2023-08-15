//
//  ReminderRepository+Injection.swift
//  VentureOut-RCIR
//
//  Created by Roman on 8/1/23.
//

import Foundation
import Factory

/// Extension of the Container class for injecting EventRepository instances.
extension Container {
    
    /// Factory method for creating and injecting a singleton instance of EventRepository.
    ///
    /// This factory method provides a way to create and inject a singleton instance of the EventRepository class.
    ///
    /// Usage example:
    /// ```
    /// let eventRepo = Container.shared.eventRepository.instance()
    /// ```
    ///
    /// - Returns: A Factory instance that can be used to retrieve an instance of EventRepository.
    public var eventRepository: Factory<EventRepository> {
        Factory(self) {
            EventRepository()
        }.singleton
    }
}
