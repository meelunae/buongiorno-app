//
//  APIResponses.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import Foundation

struct AuthTokenResponse: Codable {
    let token: String
}

struct ErrorResponse: Codable {
    let error: Bool
    let reason: String
}
