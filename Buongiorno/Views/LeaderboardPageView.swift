//
//  LeaderboardPageView.swift
//  Buongiorno
//
//  Created by Meelunae on 31/07/23.
//

import SwiftUI
import SwiftUIIntrospect
import ViewExtractor
import SDWebImageSwiftUI

struct LeaderboardPageView: View {
    @ObservedObject var leaderboard = Leaderboard()
    //@State var leaderboards = ["Daily", "Weekly", "All-time"]
    //@State var selectedLeaderboard: String = "All-time"
    
    var body: some View {
        NavigationView {
            if leaderboard.dataIsLoaded {
                ScrollView {
                    /*
                    Picker("Leaderboard", selection: $selectedLeaderboard) {
                        ForEach(leaderboards, id: \.self) { leaderboard in
                            Text(leaderboard)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    */
                    let top3Users = {
                        leaderboard.results.prefix(3)
                    }()
                    let everyoneElse = {
                        leaderboard.results.dropFirst(3)
                    }()
                    
                    DividedVStack {
                        ForEach(top3Users) { user in
                            LeaderboardUserView(user: user)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    if everyoneElse.count != 0 {
                        DividedVStack {
                            ForEach(everyoneElse) { user in
                                LeaderboardUserView(user: user)
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                Text(Image(systemName: "heart"))
                            })
                            .padding()
                            .frame(maxWidth: 30)
                            NavigationLink(destination: {
                                ProfilePageView()
                            }, label: {
                                WebImage(url: URL(string: "https://eleuna.me/assets/img/pfp.png"))
                                           .resizable()
                                           .frame(width: 30, height: 30)
                                           .aspectRatio(contentMode: .fit)
                                           .clipShape(.circle)
                            })
                            .frame(maxWidth: 30)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Leaderboard")
                            .fontWeight(.bold)
                            .font(.title)
                        .padding()
                    }
                })
                .navigationBarBackButtonHidden(true)
            }
        }
        .introspect(.navigationView(style: .stack), on: .iOS(.v16, .v17)) { controller in
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            controller.navigationBar.items?.first?.scrollEdgeAppearance = navigationBarAppearance
        }
    }
}

struct User: Identifiable {
    var id = UUID()
    var username: String
    var placement: Int
}

struct LeaderboardUserView: View {
    var user: LeaderboardUserDTO
    var body: some View {
        HStack(spacing:0) {
            PlacementBadge(user.placement)
                .padding(.horizontal, 10)
            AsyncImage(url: URL(string: user.profilePicture), content: {
                image in
                image.resizable()
                    .scaledToFill()
            }, placeholder: {
                Color.gray
            })
            .frame(maxHeight: 50)
            .clipShape(Circle())
            
            Text(user.username)
                .font(.body)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading) // makes it fill as much space as it can
            Text("\(user.score) pts")
                .font(.callout)
                .fontWeight(.regular)
        }
    }
}

struct PlacementBadge: View {
    var placement: Int
    
    init(_ placement: Int) {
        self.placement = placement
    }
    
    var body: some View {
        let color: Color = {
            switch self.placement {
            case 1: .init(red: 0.965, green: 0.816, blue: 0.270)
            case 2: .gray
            case 3: .brown
            default: .black
            }
        }()
        Text("\(placement)")
            .background(content: {
                if placement <= 3 {
                    Image(systemName: "seal.fill")
                        .imageScale(.large)
                        .brightness(0.3)
                }
            })
            .font(.callout)
            .foregroundStyle(color)
    }
}

// MARK: - Dividers between views
struct DividedVStack<Content: View>: View {
    @ViewBuilder let content: Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        Extract(content) { views in
            VStack(alignment: alignment, spacing: spacing) {
                let first = views.first?.id
                
                ForEach(views) { view in
                    if view.id != first {
                        Divider()
                    }
                    
                    view
                }
            }
        }
    }
}

#Preview {
    LeaderboardPageView()
}
