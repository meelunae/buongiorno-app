//
//  ProfilePageView.swift
//  Buongiorno
//
//  Created by Meelunae on 01/08/23.
//

import PhotosUI
import SwiftUI


struct ProfilePageView: View {
    @StateObject var viewModel : ProfileViewModel
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingEditSheet: Bool = false
    
    var body: some View {
        NavigationStack {
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
                                .fontWeight(.bold)
                                .padding(.top)
                            }
                            Spacer()
                            CircularProfilePicture(profilePictureUri: $viewModel.profilePictureURL)
                            Text(viewModel.displayName)
                                .font(.title)
                                .fontWeight(.semibold)
                            Text("@\(viewModel.username) • \(viewModel.pronouns)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            if (viewModel.bio != "") {
                                Text(viewModel.bio)
                            }
                            HStack {
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                    Label("\(viewModel.friendsCount) Friends", systemImage: "person.2.fill")
                                        .labelStyle(CustomLabel(spacing: 5))
                                })
                                .foregroundColor(.orange)
                                .padding()
                                Button(action: {}, label: {
                                    Label("\(viewModel.scoreCount) Points", systemImage: "sparkles")
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
                            viewModel.isLoggedIn = false
                            KeychainWrapper.standard.removeObject(forKey: "GdayAuthToken")
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
                                Text(Image(systemName: "heart"))
                            })
                            .padding()
                            .frame(maxWidth: 30)
                            Button(action: {
                                
                            }, label: {
                                Text(Image(systemName: "person.crop.circle.fill"))
                            })
                            .frame(maxWidth: 30)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Text(viewModel.username)
                            .fontWeight(.bold)
                            .font(.title)
                        .padding()
                    }
                })
            }
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            NavigationStack {
                EditProfileSheetView(viewModel: viewModel, isShowingSheet: $isPresentingEditSheet)
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
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var isShowingSheet: Bool
    @State var displayName: String = ""
    @State var username: String = ""
    @State var bio: String = ""

    var body: some View {
        VStack {
            Spacer()
            CircularProfilePicture(profilePictureUri: $viewModel.profilePictureURL)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
            }
            Spacer()
            Form {
                LabeledContent {
                    TextField("Display name", text: $displayName)
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
                    TextField("Pronouns", text: $username)
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
                    TextField("Bio", text: $bio)
                        .autocapitalization(.none)
                        .foregroundStyle(.foregroundText)
                } label: {
                 Text("Bio")
                        .fontWeight(.semibold)
                        .frame(width: 100)
                        .multilineTextAlignment(.trailing)
                }
                .listRowInsets(EdgeInsets()) // Remove padding for the form row

            }
            .tint(.orange)
            .foregroundColor(.orange)
            .scrollContentBackground(.hidden)

        }
        .onAppear {
            displayName = viewModel.displayName
            username = viewModel.username
            bio = viewModel.bio
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

struct CircularProfilePicture: View {
    @Binding var profilePictureUri: String
    var body: some View {
        AsyncImage(url: URL(string: profilePictureUri), content: {
            image in
            image.resizable()
                .scaledToFill()
        }, placeholder: {
            ProgressView()
        })
        .frame(width:100, height: 100, alignment: .center)
        .clipShape(Circle())

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
    ProfilePageView(viewModel: ProfileViewModel())
}

