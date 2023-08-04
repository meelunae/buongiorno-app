//
//  ContentView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        /*NavigationView {
         LoginPageView()
         .navigationBarHidden(true)
         }
         .padding()
         */
        if isLoggedIn {
            TabView {
                LeaderboardPageView()
                    .tabItem {
                        Label("Leaderboard", systemImage: "trophy")
                    }
                ProfilePageView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
            }
        } else {
            NavigationView {
                LoginPageView()
            }
        }

    }
}

struct LoginTextField: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .frame(width: 300, height: 50)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
    }
}

struct SecureLoginTextField: View {
    @Binding var text: String
    var placeholder: String
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .frame(width: 300, height: 50)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
