//
//  Test.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/17/23.
//

import SwiftUI

struct Test: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("5")
                    .font(.footnote.weight(.bold))
                    .padding()
                    .background(.yellow)
                Text("5")
                    .font(.footnote.weight(.bold))
                    .padding()
                    .background( content: {
                        Image(systemName: "star")
                            .symbolVariant(.fill)
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                            .offset(y: -2)
                    })
                    .background(.yellow)
                
                Text("5")
                    .font(.footnote.weight(.bold))
                    .padding()
                    .background( content: {
                        Circle()
                            .fill(.yellow.opacity(0.6))
                        
                        Image(systemName: "star")
                            .symbolVariant(.fill)
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                            .offset(y: -2)
                    })
                  
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
