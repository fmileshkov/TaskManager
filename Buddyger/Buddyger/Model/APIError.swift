//
//  APIError.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case unauthorized
}
