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
    @ObservedObject var leaderboard = Leaderboard()
    @State var leaderboards = ["Daily", "Weekly", "All-time"]
    @State var selectedLeaderboard: String = "All-time"
    
    var body: some View {
        NavigationView {
            if leaderboard.dataIsLoaded {
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
                            Button(action: {
                                
                            }, label: {
                                Text(Image(systemName: "person.crop.circle.fill"))
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
            .background(Color(uiColor: .systemGroupedBackground))
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
            Text("\(user.score) points")
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

class Leaderboard: ObservableObject {
    @Published var dataIsLoaded: Bool = false
    @Published var results: [LeaderboardUserDTO] = []
    
    init() {
        fetchLeaderboard()
    }
    
    func fetchLeaderboard() {
        guard let url = URL(string: "http://127.0.0.1:1337/buongiorno/leaderboard") else {
            return
        }
        
        guard let authToken = KeychainWrapper.standard.string(forKey: "GdayAuthToken") else {
            return
        }
                
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    if let successResponse = try? decoder.decode(APIResponse<[LeaderboardUserDTO]>.self, from: data) {
                        print(successResponse)
                        guard let rankings = successResponse.data else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.results = rankings
                            self.dataIsLoaded = true
                        }
                    } else if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                        print(errorResponse)
                        return
                    } else {
                        print("Something went wrong.")
                        return
                    }
                }
            }
        }
        task.resume()
    }
}


#Preview {
    LeaderboardPageView()
}
