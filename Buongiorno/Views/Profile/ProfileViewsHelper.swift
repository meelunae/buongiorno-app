//
//  ProfileViewsHelper.swift
//  Buongiorno
//
//  Created by Meelunae on 13/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CircularProfilePicture: View {
  @Binding var profilePictureUri: String
  var body: some View {
      HStack {
          WebImage(url: URL(string: profilePictureUri))
              .resizable()
              .frame(width: 70, height: 70)
              .aspectRatio(contentMode: .fit)
              .clipShape(.circle)
      }
  }
}

struct CustomLabel: LabelStyle {
  var spacing: Double = 0.0
  
  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: spacing) {
      configuration.icon
      configuration.title
    }
  }
}
