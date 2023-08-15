//
//  ButtonView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/17/23.
//

import SwiftUI

/// A customizable button component with various styling options.
struct ButtonView: View {
    typealias ActionHandler = () -> Void

    /// The title text displayed on the button.
    let title: String
    /// The background color of the button.
    let background: Color
    /// The foreground color (text color) of the button.
    let foreground: Color
    /// The border color of the button.
    let border: Color
    /// The action handler to execute when the button is tapped.
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 10

    init(
        title: String,
        background: Color = .blue,
        foreground: Color = .white,
        border: Color = .clear,
        handler: @escaping ActionHandler
    ) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
    }
}

struct ButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonView(title: "Primary") {}
                .preview(with: "Primary view ")
            ButtonView(title: "Secondary") {}
                .preview(with: "Secondary view ")
        }
    }
}
