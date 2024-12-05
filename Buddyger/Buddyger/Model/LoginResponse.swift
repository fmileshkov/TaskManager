//
//  LoginResponse.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let refreshToken: String
}
