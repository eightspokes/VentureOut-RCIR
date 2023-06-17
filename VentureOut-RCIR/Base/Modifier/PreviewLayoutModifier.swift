//
//  PreviewLayoutModifier.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/16/23.
//

import SwiftUI


struct PreviewLayoutComponentModifier: ViewModifier{
    
    let name: String
    
    func body(content: Content) -> some View{
        
        content
            .previewLayout(.sizeThatFits)
            .previewDisplayName(name)
            .padding()
    }
    
}

extension View{
    func preview(with name: String) -> some View {
        self.modifier(PreviewLayoutComponentModifier(name: name))
    }
}
