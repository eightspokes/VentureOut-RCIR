//
//  SlideInMenuService.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/26/23.
//

import Foundation
import SwiftUI
//ViewModel for SlideIn menu
@MainActor
class SlideInMenuViewModel: ObservableObject {
    @Published var isPresented = false
    func toggleMenu() {
        withAnimation(.spring()) {
            self.isPresented.toggle()
        }
    }
}
