//
//  OnboardingData.swift
//  Buongiorno
//
//  Created by Meelunae on 04/08/23.
//

struct OnboardingData: Hashable, Identifiable {
    let id: Int
    let objectImage: String
    let primaryText: String 
    let secondaryText: String
    
    static let list: [OnboardingData] = [
        OnboardingData(id: 0, objectImage: "sun.and.horizon.fill", primaryText: "Start your day spreading good vibes", secondaryText: "With Buongiorno, you can make someone's day brighter with just a simple \"Good morning\"!"),
        OnboardingData(id: 1, objectImage: "bell.fill", primaryText: "Enable Push Notifications", secondaryText: "Get reminded to send your daily greetings and receive notifications when others send you their warm wishes."),
        OnboardingData(id: 2, objectImage: "trophy.fill", primaryText: "Join in the competition", secondaryText: "Stay connected, earn points, and climb the rankings while making someone's day brighter with a simple \"Good Morning\".")
    ]
}
