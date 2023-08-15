//
//  SettingsRowView.swift
//  VentureOut-RCIR
//
//  Created by Roman on 6/26/23.
//

import SwiftUI

/// A view component for displaying a settings row with an icon and a title.
struct SettingsRowView: View {
    /// The name of the SF Symbol image to display.
    let imageName: String
    /// The title text to display.
    let title: String
    /// The tint color for the SF Symbol.
    let tintColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            Spacer()
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "lock", title: "This is a title", tintColor: .gray)
    }
}
