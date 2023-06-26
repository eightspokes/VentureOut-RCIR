//
//  LoginView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/22/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
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
                InputPasswordView(password: $password,  placeholder: "Password", sfSymbol: "lock")
                
                Button{
                    //TODO: To be implemented
                } label: {
                    HStack(){
                        Spacer()
                        Text("Forgot Password?")
                            .font(.footnote.bold())
                            
                    }
                }

                
                ButtonView(title: "Sign in"){
                    
                    Task{
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                    
                }
                .padding(.vertical)
                Spacer()
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                }label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .bold()
                    }
                }
            }
            .padding(.horizontal)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
