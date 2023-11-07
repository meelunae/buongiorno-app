//
//  ContentView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var selfProfileViewModel = ProfileViewModel()
    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        if isLoggedIn {
            TabView {
                ProfilePageView(viewModel: selfProfileViewModel)
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        
                    }
                LeaderboardPageView()
                    .tabItem {
                        Image(systemName: "trophy")
                    }
            }
        } else {
            NavigationStack {
                LoginPageView()
            }
            .fullScreenCover(isPresented: $showOnboarding, content: {
                OnboardingView(showOnboarding: $showOnboarding)
            })
        }
    }
    
}

#Preview {
    ContentView()
}
