//
//  AppearanceSettingsView.swift
//  Buongiorno
//
//  Created by Meelunae on 02/08/23.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("selectedTheme") var selectedTheme = "Automatic"
    let themes = ["Light", "Dark", "Automatic"]

    var body: some View {
        NavigationStack {
            Form {
                Group {
                    
                    Picker("Theme", selection: $selectedTheme, content: {
                        ForEach(themes, id: \.self) {
                            Text($0)
                        }
                    })
                    .pickerStyle(.inline)
                    .onChange(of: selectedTheme, {
                        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }

                        guard let firstWindow = firstScene.windows.first else {
                            return
                        }
                        
                        switch (selectedTheme) {
                        case "Dark":
                            firstWindow.overrideUserInterfaceStyle = .dark
                            break;
                        case "Light":
                            firstWindow.overrideUserInterfaceStyle = .light
                        default:
                            firstWindow.overrideUserInterfaceStyle = .unspecified
                        }
                    })
                }
            }
        }

    }
}

#Preview {
    AppearanceSettingsView()
}
