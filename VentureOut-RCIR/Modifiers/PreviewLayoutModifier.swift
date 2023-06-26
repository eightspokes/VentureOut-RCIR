//
//  PreviewLayoutModifier.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/22/23.
//

import SwiftUI

struct PreviewLayoutModifier: ViewModifier{
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
        self.modifier(PreviewLayoutModifier(name: name))
    }
}
