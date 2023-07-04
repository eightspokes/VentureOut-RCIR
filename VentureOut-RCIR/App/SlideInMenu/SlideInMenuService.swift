//
//  SlideInMenuService.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/4/23.
//

import SwiftUI

class SlideInMenuService: ObservableObject {
    @Published var isPresented = false
    
    
    func toggleMenu() {
      //  withAnimation(.spring()) {
            self.isPresented.toggle()
       // }
    }
}
