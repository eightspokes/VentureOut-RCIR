//
//  RegistrationView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/25/23.
//

import SwiftUI

/// A view for user registration.
struct RegistrationView: View {
    
    @State var isAddingOtherRower: Bool
    
    @State private var email = ""
    @State private var firstName = ""
    @State private var secondName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                //DynamicBackgroundView()
                VStack(spacing: 15) {
                    Image("rowers")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 32)
                    Text("RCIR")
                        .font(.custom("Sacramento-Regular", size: 35, relativeTo: .title))
                        .padding(.vertical, -70)
                    
                    InputTextFieldView(text: $email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                        .autocapitalization(.none)
                    
                    InputTextFieldView(text: $firstName, placeholder: "First name", keyboardType: .default, sfSymbol: nil)
                    
                    InputTextFieldView(text: $secondName, placeholder: "Second name", keyboardType: .default, sfSymbol: nil)
                    
                    InputPasswordView(password: $password,  placeholder: "Password", sfSymbol: "lock")
                    
                    ZStack(alignment: .trailing) {
                        InputPasswordView(password: $confirmPassword,  placeholder: "Confirm Password", sfSymbol: "lock")
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword && password.count > 5 {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else if password == confirmPassword {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGray))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                    ButtonView(title: isAddingOtherRower ? "REGISTER" : "SIGN UP") {
                        Task {
                            if isAddingOtherRower {
                                try await authViewModel.addNewRower(withEmail: email, password: password, fullName: "\(firstName)  \(secondName)")
                                // Update the state in the parent view when a new rower is added.
                                print("Before dismiss called")
                                dismiss()
                                print("After dismiss called")
                            } else {
                                try await authViewModel.createUser(withEmail: email, password: password, fullName: "\(firstName)  \(secondName)")
                            }
                        }
                    }
                    .padding(.vertical)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        if isAddingOtherRower {
                            Text("Cancel")
                        } else {
                            HStack {
                                Text("Already have an account?")
                                Text("Sign in")
                                    .bold()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol Extension

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && confirmPassword == password
            && !firstName.isEmpty
            && !secondName.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isAddingOtherRower: true)
    }
}
