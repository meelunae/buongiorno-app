//
//  FriendsListView.swift
//  Buongiorno
//
//  Created by Meelunae on 09/11/23.
//

import SDWebImageSwiftUI
import SwiftUI

struct FriendsListView: View {
    var body: some View {
       Text("Hello world!")
    }
}

struct FriendsListRowView: View {
    @EnvironmentObject var loggedInUser: ProfileViewModel
    var friends: [UserFriendDTO]
    var body: some View {
        let profileViewModel = ProfileViewModel()
        NavigationView {
            if profileViewModel.friendsCount == 0 {
                Text("Hello world!")
            } else {
                Text("Hello world!")
                /*
                 List {
                 ForEach(friends, id: \._id) { friend in
                 HStack {
                 WebImage(url: URL(string: friend.profilePicture))
                 .resizable()
                 .frame(width: 50, height: 50)
                 .aspectRatio(contentMode: .fit)
                 .clipShape(.circle)
                 Spacer()
                 VStack {
                 Text(friend.displayName)
                 Text(friend.username)
                 }
                 }
                 }
                 }
                 }
                 */
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text(Image(systemName: "heart"))
                    })
                    .padding()
                    .frame(maxWidth: 30)
                    NavigationLink(destination: {
                        ProfilePageView()
                    }, label: {
                        WebImage(url: URL(string: profileViewModel.profilePictureURL))
                            .resizable()
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.circle)
                    })
                    .frame(maxWidth: 30)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text(profileViewModel.username)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
            }
        })
        .navigationBarBackButtonHidden(true)
    }
}
    #Preview {
        FriendsListView()
    }
    
