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
    let id : String
    let profilePicture: String
    let username: String
    let displayName: String
    let bio: String
    let pronouns: String
    let score: Int
    let friends: Int
}

struct AuthTokenResponse: Codable {
    let token: String
}

struct ErrorResponse: Codable {
    let error: Bool
    let reason: String
}



struct LeaderboardUserDTO: Codable, Identifiable {
    let id: UUID
    let profilePicture: String
    let username: String
    let score: Int
    let placement: Int
}
