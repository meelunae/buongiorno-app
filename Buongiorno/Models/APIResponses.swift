//
//  APIResponses.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import Foundation

struct APIError: Codable {
    let code: Int
    let message: String
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let error : APIError?
    let data: T?
    let message: String?
}

struct UserDetailsDTO: Codable {
    let _id : String
    let profilePicture: String
    let username: String
    let displayName: String
    let bio: String
    let pronouns: String
    let score: Int
    let friends: Int
}

struct UserFriendDTO: Codable {
    let _id: String
    let profilePicture: String
    let displayName: String
    let username: String
}

struct AuthTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
}

struct ErrorResponse: Codable {
    let error: Bool
    let reason: String
}



struct LeaderboardUserDTO: Codable, Identifiable {
    let _id: String
    let profilePicture: String
    let username: String
    let score: Int
    let placement: Int
    var id: String {
        _id
    }
}
