//
//  ContentView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/22/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel:  AuthViewModel
    var body: some View {
        if authViewModel.userSession != nil {
            ProfileView()
        }else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
