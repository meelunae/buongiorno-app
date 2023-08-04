//
//  BuongiornoApp.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI

@main
struct BuongiornoApp: App {
    @AppStorage("selectedTheme") var selectedTheme = "Automatic"

    var body: some Scene {
        WindowGroup {
            if selectedTheme == "Automatic" {
                ContentView()
            } else {
                ContentView()
                    .preferredColorScheme(selectedTheme == "Dark" ? .dark : .light)
            }
        }
    }
}
