//
//  ProfilePageView.swift
//  Buongiorno
//
//  Created by Meelunae on 01/08/23.
//

import SwiftUI


struct ProfilePageView: View {
    @State var isDarkModeEnabled: Bool = true
    var body: some View {
        NavigationView {
                    Form {
                        Group {
                            HStack{
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image("profilePic")
                                        .resizable()
                                        .frame(width:100, height: 100, alignment: .center)

                                    Text("displayName")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Text("@username • they/them")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("userBio")
                                    HStack {
                                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                            Label("113 Friends", systemImage: "person.2.fill")
                                                .labelStyle(CustomLabel(spacing: -0.5))
                                        })
                                        .foregroundColor(.orange)
                                        .padding()
                                        Button(action: {}, label: {
                                            Label("2.1K Points", systemImage: "sparkles")
                                                .labelStyle(CustomLabel(spacing: -0.5))
                                        })
                                        .foregroundColor(.orange)
                                        .padding()

                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        Section(header: Text("Settings"), content: {
                            HStack{
                                Image(systemName: "person.circle.fill")
                                Text("Account Details")
                            }

                            HStack{
                                Image(systemName: "bell.badge")
                                Text("Notifications")
                            }
                            
                            HStack{
                                Image(systemName: "moon.fill")
                                Text("Appearance")
                            }

                        })

                        Section(header: Text("About"), content: {
                            HStack{
                                Image(systemName: "info.circle.fill")
                                Text("About this App")
                            }
                            HStack{
                                Image(systemName: "ant.fill")
                                Text("Report Bugs")
                            }
                        })
                    }
                    .navigationBarTitle("Profile")
                    .background(Color(uiColor: .systemGroupedBackground))
                }
            .introspect(.navigationView(style: .stack), on: .iOS(.v16, .v17)) { controller in
              let navigationBarAppearance = UINavigationBarAppearance()
              navigationBarAppearance.configureWithDefaultBackground()
              controller.navigationBar.items?.first!.scrollEdgeAppearance = navigationBarAppearance
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

