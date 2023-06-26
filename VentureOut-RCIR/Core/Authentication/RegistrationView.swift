//
//  RegistrationView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/25/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var firstName = ""
    @State private var secondName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var authViewModel:  AuthViewModel
    var body: some View {
        
            NavigationStack{
                VStack(spacing: 15){
                    Image("rowers")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 32)
                    Text("Venture Out")
                        .font(.custom("Sacramento-Regular", size: 35, relativeTo: .title))
                        .padding(.vertical, -70)
                   
                    
                    InputTextFieldView(text: $email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                        .autocapitalization(.none)
                    
                    InputTextFieldView(text: $firstName, placeholder: "First name", keyboardType: .default, sfSymbol: nil)
                    InputTextFieldView(text: $secondName, placeholder: "Second name", keyboardType: .default, sfSymbol: nil)
                        
                    
                    
                    
                    InputPasswordView(password: $password,  placeholder: "Password", sfSymbol: "lock")
                    InputPasswordView(password: $confirmPassword,  placeholder: "Confirm Password", sfSymbol: "lock")
                    
                    ButtonView(title: "SIGN UP"){
                        Task{
                            try await authViewModel.createUser(withEmail: email, password: password)
                        }
                        
                    }
                    .padding(.vertical)
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Already have an account?")
                            Text("Sign in")
                                .bold()
                        }
                    }

                    
                }
                .padding(.horizontal)
                
                
            }
        }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
