//
//  ProfilePageView.swift
//  Buongiorno
//
//  Created by Meelunae on 01/08/23.
//

import SwiftUI


struct ProfilePageView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    @AppStorage("displayName") var authedDisplayName: String = "undefined"
    @AppStorage("username") var authedUsername: String = "undefined"
    @AppStorage("bio") var authedBio: String = "undefined"
    @AppStorage("profilePicture") var authedProfilePicture: String = ""
    @AppStorage("friends") var authedFriends: Int = 0
    @AppStorage("score") var authedScore: Int = 0
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingEditSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    HStack(spacing:8) {
                        Spacer()
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.isPresentingEditSheet = true
                                }, label:
                                        {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .imageScale(.large)
                                        .foregroundStyle(Color.orange)
                                        .frame(maxWidth: 35)

                                })
                                .padding(.top)
                            }
                            Spacer()
                            
                            AsyncImage(url: URL(string: authedProfilePicture), content: {
                                image in
                                image.resizable()
                                    .scaledToFill()
                            }, placeholder: {
                                Color.gray
                            })
                            .frame(width:100, height: 100, alignment: .center)
                            .clipShape(Circle())
                            
                            Text(authedDisplayName)
                                .font(.title)
                                .fontWeight(.semibold)
                            Text("@\(authedUsername) • they/them")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(authedBio)
                            HStack {
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("\(authedFriends) Friends", systemImage: "person.2.fill")
                                        .labelStyle(CustomLabel(spacing: 5))
                                })
                                .foregroundColor(.orange)
                                .padding()
                                Button(action: {}, label: {
                                    Label("\(authedScore) Points", systemImage: "sparkles")
                                        .labelStyle(CustomLabel(spacing: 5))
                                })
                                .foregroundColor(.orange)
                                .padding()
                                
                            }
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Settings"), content: {
                    
                    HStack(spacing:8) {
                        Image(systemName: "person.circle.fill")
                        Text("Account Details")
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
                            self.isLoggedIn = false
                            KeychainWrapper.standard.removeObject(forKey: "GdayAuthToken")
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                })
            }
            .navigationBarTitle("Profile")
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            NavigationView {
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

struct EditProfileSheetView: View {
    @State var displayName: String = ""
    @State var username: String = ""
    @State var bio: String = ""
    @Binding var isShowingSheet: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Display name")
                TextField("Display name", text: $displayName)
            }
            .padding()
            
            HStack {
                Text("Username")
                TextField("Display name", text: $username)
            }
            .padding()

            HStack {
                Text("Bio")
                TextField("Display name", text: $bio)
            }
            .padding()

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
                    
                }, label: {
                    Text("Save")
                })
            })
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

#Preview {
    ProfilePageView()
}

