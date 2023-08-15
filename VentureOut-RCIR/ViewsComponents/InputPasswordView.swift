//
//  InputPasswordView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/17/23.
//

import SwiftUI

/// A custom secure password input field with optional icon.
struct InputPasswordView: View {
    /// The binding to the password input value.
    @Binding var password: String
    /// The placeholder text displayed when the field is empty.
    let placeholder: String
    /// The name of the SF Symbol to display as an icon.
    let sfSymbol: String?
    
    /// The leading padding for the password field.
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        SecureField(placeholder, text: $password)
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .background(
                ZStack(alignment: .leading) {
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

struct InputPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputPasswordView(password: .constant(""), placeholder: "Password", sfSymbol: "lock")
                .preview(with: "Input Password with SF Symbol")
            InputPasswordView(password: .constant(""), placeholder: "Password", sfSymbol: nil)
                .preview(with: "Input Password without SF Symbol")
        }
    }
}

