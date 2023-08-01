//
//  LeaderboardPageView.swift
//  Buongiorno
//
//  Created by Meelunae on 31/07/23.
//

import SwiftUI
import SwiftUIIntrospect
import ViewExtractor

struct LeaderboardPageView: View {
  @State var leaderboards = ["Daily", "Weekly", "All-time"]
  @State var selectedLeaderboard: String = "All-time"
  @State var users: [User] = [
    .init(username: "Albemarle", placement: 1),
    .init(username: "Brandywine", placement: 2),
    .init(username: "Chesapeake", placement: 3),
    .init(username: "meow", placement: 4),
    .init(username: "im not good", placement: 5),
    .init(username: "at names :3", placement: 6)
  ]
  var body: some View {
    NavigationView {
      ScrollView {
        Picker("Leaderboard", selection: $selectedLeaderboard) {
          ForEach(leaderboards, id: \.self) { leaderboard in
            Text(leaderboard)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 30)
        .padding(.top, 30)
        
        let top3Users = {
          users.prefix(3)
        }()
        let everyoneElse = {
          users.dropFirst(3)
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
      .navigationTitle("Leaderboard")
      .background(Color(uiColor: .systemGroupedBackground))
    }
    .introspect(.navigationView(style: .stack), on: .iOS(.v16, .v17)) { controller in
      let navigationBarAppearance = UINavigationBarAppearance()
      navigationBarAppearance.configureWithDefaultBackground()
      controller.navigationBar.items?.first!.scrollEdgeAppearance = navigationBarAppearance
    }
  }
}

struct User: Identifiable {
  var id = UUID()
  var username: String
  var placement: Int
}

struct LeaderboardUserView: View {
  var user: User
  var body: some View {
    HStack {
      PlacementBadge(user.placement)
        .padding(.horizontal, 10)
      Image("profilePic")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .frame(maxHeight: 50)
      Text(user.username)
        .font(.body)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading) // makes it fill as much space as it can
      Text("2.1k points")
        .font(.caption)
        .fontWeight(.light)
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
