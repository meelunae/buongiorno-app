//
//  BuongiornoApp.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImagePhotosPlugin

@main
struct BuongiornoApp: App {
    @AppStorage("selectedTheme") var selectedTheme = "Automatic"
    @StateObject var loggedInUser = ProfileViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if selectedTheme == "Automatic" {
                ContentView()
                .environmentObject(loggedInUser)

            } else {
                ContentView()
                    .preferredColorScheme(selectedTheme == "Dark" ? .dark : .light)
                    .environmentObject(loggedInUser)
            }
        }
    }
}
