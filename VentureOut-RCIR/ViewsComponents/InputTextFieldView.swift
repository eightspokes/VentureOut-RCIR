//
//  InputTextFieldView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/16/23.
//

import SwiftUI

/// A custom text input field with optional icon and specified keyboard type.
struct InputTextFieldView: View {
    /// The binding to the text input value.
    @Binding var text: String
    /// The placeholder text displayed when the field is empty.
    let placeholder: String
    /// The type of keyboard to be displayed.
    let keyboardType: UIKeyboardType
    /// The name of the SF Symbol to display as an icon.
    let sfSymbol: String?
    
    /// The leading padding for the text field.
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .keyboardType(keyboardType)
            .background(
                ZStack(alignment: .leading){
                    if let systemImage = sfSymbol {
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 5)
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.gray.opacity(0.25))
                }
            )
    }
}

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputTextFieldView(text: .constant(""), placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                .preview(with: "Text Input with SF Symbol")
            
            InputTextFieldView(text: .constant(""), placeholder: "First Name", keyboardType: .emailAddress, sfSymbol: nil)
                .preview(with: "Input First Name")
        }
    }
}
