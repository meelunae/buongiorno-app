//
//  ContentView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /*NavigationView {
         LoginPageView()
         .navigationBarHidden(true)
         }
         .padding()
         */
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
