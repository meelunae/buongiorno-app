//
//  EditProfileSheetView.swift
//  Buongiorno
//
//  Created by Meelunae on 13/11/23.
//

import PhotosUI
import SwiftUI

struct EditProfileSheetView: View {
  @EnvironmentObject var loggedInUser: ProfileViewModel
  @Binding var isShowingSheet: Bool
  @State var displayName: String = ""
  @State var pronouns: String = ""
  @State var bio: String = ""
  
  var body: some View {
    VStack {
      Spacer()
      CircularProfilePicture(profilePictureUri: $loggedInUser.profilePictureURL)
        .overlay(alignment: .bottomTrailing) {
          PhotosPicker(selection: $loggedInUser.imageSelection,
                       matching: .images,
                       photoLibrary: .shared()) {
            Image(systemName: "pencil.circle.fill")
              .symbolRenderingMode(.multicolor)
              .font(.system(size: 20))
              .foregroundColor(.accentColor)
          }
        .buttonStyle(.borderless)
        }
        .onChange(of: loggedInUser.imageSelection) {
            guard let selectedImage = loggedInUser.imageSelection else { return }
            guard let localID = selectedImage.itemIdentifier else { return }
            let result = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
            if let asset = result.firstObject {
                guard let urlString = NSURL.sd_URL(with: asset).absoluteString else { return }
                loggedInUser.profilePictureURL = urlString
            }
        }
      Spacer()
      Form {
        LabeledContent {
          TextField("Your display name", text: $displayName)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .foregroundStyle(.foregroundText)
        } label: {
          Text("Name")
            .fontWeight(.semibold)
            .frame(width: 100)
            .multilineTextAlignment(.trailing)
        }
        .listRowInsets(EdgeInsets()) // Remove padding for the form row
        
        
        LabeledContent {
          TextField("he/him, she/her, they/them", text: $pronouns)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .foregroundStyle(.foregroundText)
        } label: {
          Text("Pronouns")
            .fontWeight(.semibold)
            .frame(width: 100)
            .multilineTextAlignment(.trailing)
        }
        .listRowInsets(EdgeInsets()) // Remove padding for the form row
        
        
        LabeledContent {
          TextField("Hello! I am a 24 years old student from Italy.", text: $bio)
            .autocapitalization(.none)
            .foregroundStyle(.foregroundText)
        } label: {
          Text("Bio")
            .fontWeight(.semibold)
            .frame(width: 100)
            .multilineTextAlignment(.trailing)
        }
        .listRowInsets(EdgeInsets())
      }
      .tint(.orange)
      .foregroundColor(.orange)
      .scrollContentBackground(.hidden)
      
    }
    .onAppear {
      displayName = loggedInUser.displayName
      pronouns = loggedInUser.pronouns
      bio = loggedInUser.bio
    }
    .navigationBarTitle("Edit profile", displayMode: .inline)
    .toolbar {
      ToolbarItem(placement: .topBarLeading, content: {
        Button(action: {
          self.isShowingSheet = false
        }, label: {
          Text("Cancel")
        })
      })
      ToolbarItem(placement: .topBarTrailing, content: {
        Button(action: {
            loggedInUser.patchProfileData(displayName: displayName, pronouns: pronouns, bio: bio) { success in
            if success {
              self.isShowingSheet = false
            }
          }
        }, label: {
          Text("Save")
        })
      })
    }
  }
}
