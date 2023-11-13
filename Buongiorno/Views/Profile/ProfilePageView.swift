//
//  ProfilePageView.swift
//  Buongiorno
//
//  Created by Meelunae on 01/08/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfilePageView: View {
  @EnvironmentObject var loggedInUser: ProfileViewModel
  @State private var isPresentingConfirm: Bool = false
  @State private var isPresentingEditSheet: Bool = false
  @State var profileSize: CGSize = .zero
  
  var body: some View {
	NavigationStack {
	  List {
		HStack(spacing:8) {
		  Spacer()
		  VStack {
			HStack {
			  Spacer()
			  Button(action: {
				self.isPresentingEditSheet = true
			  }, label: {
				Image(systemName: "pencil.circle.fill")
				  .resizable()
				  .scaledToFit()
				  .imageScale(.large)
				  .foregroundStyle(Color.orange)
				  .frame(maxWidth: 35)
			  })
			  .fontWeight(.bold)
			  .padding(.top)
			}
			Spacer()
			CircularProfilePicture(profilePictureUri: $loggedInUser.profilePictureURL)
			Text(loggedInUser.displayName)
			  .font(.title)
			  .fontWeight(.semibold)
			Text("@\(loggedInUser.username) • \(loggedInUser.pronouns)")
			  .font(.subheadline)
			  .foregroundColor(.gray)
			Spacer()
			if (loggedInUser.bio != "") {
			  Text(loggedInUser.bio)
				.frame(maxWidth: profileSize.width)
			}
			HStack {
			  Button(action: {}, label: {
                  if (loggedInUser.friendsCount == 1) {
                      Label("\(loggedInUser.friendsCount) Friend", systemImage: "person.2.fill")
                        .labelStyle(CustomLabel(spacing: 5))
                  } else {
                      Label("\(loggedInUser.friendsCount) Friends", systemImage: "person.2.fill")
                        .labelStyle(CustomLabel(spacing: 5))
                  }
			  })
			  .foregroundColor(.orange)
			  .padding()
			  Button(action: {}, label: {
				Label("\(loggedInUser.scoreCount) Points", systemImage: "sparkles")
				  .labelStyle(CustomLabel(spacing: 5))
			  })
			  .foregroundColor(.orange)
			  .padding()
			  
			}
		  }
		  .bindSize(to: $profileSize)
		  Spacer()
		}
		
		Section(header: Text("Settings"), content: {
		  
            NavigationLink(destination: AppearanceSettingsView() .navigationTitle("Account Details")) {
              HStack(spacing:8) {
                Image(systemName: "person.circle.fill")
                Text("Account Details")
              }
            }
            
		  HStack(spacing:8) {
			Image(systemName: "bell.badge.circle.fill")
			Text("Notifications")
		  }
		  
		  NavigationLink(destination: AppearanceSettingsView() .navigationTitle("Appearance")) {
			HStack(spacing:8) {
			  Image(systemName: "moon.circle.fill")
			  Text("Appearance")
			}
		  }
		})
		
		Section(header: Text("About"), content: {
		  HStack(spacing:8) {
			Image(systemName: "info.circle.fill")
			Text("About this App")
		  }
		  HStack(spacing:8) {
			Image(systemName: "ant.circle.fill")
			Text("Report Bugs")
		  }
		})
		
		Section(content: {
		  Button {
			isPresentingConfirm = true
		  } label: {
			HStack(spacing:8) {
			  Image(systemName: "arrow.left.to.line")
			  Text("Log Out")
			}
		  }
		  .foregroundStyle(Color.red)
		  .confirmationDialog("Are you sure you want to log out?",
							  isPresented: $isPresentingConfirm) {
			Button("Log out", role: .destructive) {
			  loggedInUser.isLoggedIn = false
			  KeychainWrapper.standard.removeObject(forKey: "BuongiornoAccessToken")
              KeychainWrapper.standard.removeObject(forKey: "BuongiornoRefreshToken")
			}
		  } message: {
			Text("Are you sure you want to log out?")
		  }
		})
		.toolbar(content: {
		  ToolbarItem(placement: .topBarTrailing) {
			HStack {
			  Button(action: {
				
			  }, label: {
				Text(Image(systemName: "heart.fill"))
			  })
			  .padding()
			  .frame(maxWidth: 25)
			  NavigationLink(destination: {
                  ProfilePageView()
			  }, label: {
                  WebImage(url: URL(string: loggedInUser.profilePictureURL))
                             .resizable()
                             .frame(width: 25, height: 25)
                             .aspectRatio(contentMode: .fit)
                             .clipShape(.circle)
			  })
			  .frame(maxWidth: 30)
			}
		  }
		  
		  ToolbarItem(placement: .topBarLeading) {
			Text("@\(loggedInUser.username)")
                .fontWeight(.semibold)
                .font(.title2)
                .padding()
		  }
		})
	  }
      .navigationBarBackButtonHidden(true)
	  .background(Color(uiColor: .systemGroupedBackground))
	}
	.sheet(isPresented: $isPresentingEditSheet) {
	  NavigationStack {
          EditProfileSheetView(isShowingSheet: $isPresentingEditSheet)
	  }
	  .presentationDetents([.medium])
	  .presentationDragIndicator(.hidden)
	  
	}
	.introspect(.navigationView(style: .stack), on: .iOS(.v16, .v17)) { controller in
	  let navigationBarAppearance = UINavigationBarAppearance()
	  navigationBarAppearance.configureWithDefaultBackground()
	  controller.navigationBar.items?.first!.scrollEdgeAppearance = navigationBarAppearance
	}
  }
}

#Preview {
    ProfilePageView()
}

