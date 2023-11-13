//
//  LeaderboardViewModel.swift
//  Buongiorno
//
//  Created by Meelunae on 09/11/23.
//

import SwiftUI

class Leaderboard: ObservableObject {
  @Published var dataIsLoaded: Bool = false
  @Published var results: [LeaderboardUserDTO] = []
  
  init() {
    fetchLeaderboard()
  }
  
  func fetchLeaderboard() {
    Task {
      let url = URL(string: "http://127.0.0.1:1337/api/buongiorno/leaderboard")!
      guard let authToken = KeychainWrapper.standard.string(forKey: "BuongiornoAccessToken") else { return }
      var (data, response): (Data, URLResponse)
      var req = URLRequest(url: url)
      req.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
      req.setValue("application/json", forHTTPHeaderField: "Content-Type")
      do {
        (data, response) = try await URLSession.shared.data(for: req)
        guard let res = response as? HTTPURLResponse else {
          return print("Invalid response")
        }
        
        if res.statusCode == 401 {
            try await self.refreshAuthToken()
            guard let newAuthToken = KeychainWrapper.standard.string(forKey: "BuongiornoAccessToken") else { return }
            req.setValue("Bearer \(newAuthToken)", forHTTPHeaderField: "Authorization");
            do {
                (data, response) = try await URLSession.shared.data(for: req)
                guard let res = response as? HTTPURLResponse else {
                    return print("Invalid response")
                }
            }
        }
          try parseData(data)
      } catch {
        print(error)
      }
    }
  }
  
  func parseData(_ data: Data) throws {
    let decoder = JSONDecoder()
    let successResponse = try decoder.decode(APIResponse<[LeaderboardUserDTO]>.self, from: data)
    guard let rankings = successResponse.data else { return }
    
    DispatchQueue.main.async {
      self.results = rankings
      self.dataIsLoaded = true
    }
  }
  
  func refreshAuthToken() async throws {
    guard let refreshUrl = URL(string: "http://127.0.0.1:1337/api/auth/refresh") else { return }
    guard let oldAuthToken = KeychainWrapper.standard.string(forKey: "BuongiornoAccessToken") else { return }
    guard let refreshToken = KeychainWrapper.standard.string(forKey: "BuongiornoRefreshToken") else { return }
    
    var refreshRequest = URLRequest(url: refreshUrl)
    refreshRequest.httpMethod = "POST"
    refreshRequest.setValue("Bearer \(oldAuthToken)", forHTTPHeaderField: "Authorization")
    refreshRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let requestBody: [String: Any] = ["refreshToken": refreshToken]
    
    do {
      refreshRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
      print("Request Body: \(String(data: refreshRequest.httpBody!, encoding: .utf8) ?? "Empty")")
      let (data, response) = try await URLSession.shared.data(for: refreshRequest)
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            print(httpResponse)
        }
      let decoder = JSONDecoder()
        if let tokenResponse = try? decoder.decode(AuthTokenResponse.self, from: data) {
            KeychainWrapper.standard.set(tokenResponse.accessToken, forKey: "BuongiornoAccessToken")
        } else {
            return
        }
    } catch {
      print("Error encoding request body: \(error)")
      return
    }
  }
}
