//
//  Test.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/5/23.
//

import SwiftUI

struct Test: View {
    @State var rating: Int = 3
    var body: some View {
      
        
        
        ZStack{
            starsView
                .overlay(
                   overlayView
                    .mask(starsView)
                    
                )
        }
    }
    private var overlayView: some View{
        GeometryReader { geo in
            ZStack(alignment: .leading){
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width:  CGFloat(geo.size.width / 5) * CGFloat(rating))
                
            }
        }
        .allowsHitTesting(false)
    }
    
    private var starsView: some View{
        HStack{
            ForEach(1..<6){ index in
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundColor(rating >= index ? .yellow : .gray  )
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            rating = index
                        }
                       
                    }
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
