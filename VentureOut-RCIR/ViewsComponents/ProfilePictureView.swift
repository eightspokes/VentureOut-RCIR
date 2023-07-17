//
//  ProfilePictureView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 7/17/23.
//

import SwiftUI

struct ProfilePictureView: View {
    var image: String?
    var profileImage: String{
        if let image {
            return image
        }
        return "default-icon"
    }
    var body: some View {
        VStack{
            
            Image(profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
                .frame(width: 65, height: 65)
            
                .clipShape(Circle())
                .overlay(
                    Circle()
                    .strokeBorder(
                        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center, startAngle: .zero, endAngle: .degrees(360)),
                                lineWidth: 2
                        )
                )
        }
    }
}
struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(image: nil)
    }
}
