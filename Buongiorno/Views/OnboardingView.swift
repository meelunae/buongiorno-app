//
//  OnboardingView.swift
//  Buongiorno
//
//  Created by Meelunae on 04/08/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var currentTab: Int = 0
    var body: some View {
        TabView(selection: $currentTab,
                content: {
            ForEach(OnboardingData.list) { viewData in
                OnboardingPageView(data: viewData)
                    .tag(viewData.id)
            }
        })
        .tabViewStyle(PageTabViewStyle())
    }
}


struct OnboardingPageView: View {
    var data: OnboardingData
    @AppStorage("showUserOnboarding") var showOnboarding: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: data.objectImage)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.orange)
                .padding()
                .frame(maxWidth: 100)
            
            Text(data.primaryText)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            Text(data.secondaryText)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 350)
                .foregroundColor(Color.orange)
            Spacer()
            
            Button(action: {
                self.showOnboarding = false
            }, label: {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.orange)
                    )
            })
            .shadow(radius: 3)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
