//
//  InputPasswordView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/17/23.
//

import SwiftUI

struct InputPasswordView: View {
    @Binding var password: String
    let placeholder: String
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        SecureField(placeholder, text: $password)
            .frame(maxWidth: .infinity,minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
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

struct InputPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            InputPasswordView(password: .constant(""), placeholder: "Password", sfSymbol: "lock")
                .preview(with: "Input password with sfsymbol")
            InputPasswordView(password: .constant(""), placeholder: "Password", sfSymbol: nil)
                .preview(with: "Input password without sfsymbol")
        }
        
    }
}
