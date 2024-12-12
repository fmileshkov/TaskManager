//
//  AuthManager.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 1.12.24.
//

import Foundation

protocol AuthRepositoryProtocol: AnyObject {
    
    /// Performs a login request to authenticate the user.
    ///
    /// - Returns: A `LoginResponse` object containing the access and refresh tokens.
    /// - Throws: An error if the request fails or the response is invalid.
    func login() async throws -> LoginResponse
}
    
class AuthRepository: AuthRepositoryProtocol {
    
    func login() async throws -> LoginResponse {
        guard let url = URL(string: AuthAPIConstants.baseURL) else {
            throw URLError(.badURL)
        }
        
        let requestBody: [String: Any] = [
            "username": AuthAPIConstants.username,
            "password": AuthAPIConstants.password
        ]
        let headers = [
            "Authorization": AuthAPIConstants.authorizationHeader,
            "Content-Type": AuthAPIConstants.contentType
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
            let oauth = dictionary["oauth"] as? [String: Any],
            let accessToken = oauth["access_token"] as? String,
            let refreshToken = oauth["refresh_token"] as? String
        else {
            throw URLError(.cannotParseResponse)
        }
        
        return LoginResponse(token: accessToken, refreshToken: refreshToken)
    }
    
}
