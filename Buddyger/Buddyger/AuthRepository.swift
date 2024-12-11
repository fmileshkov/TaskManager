//
//  AuthManager.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 1.12.24.
//

import Foundation

protocol AuthRepositoryProtocol: AnyObject {
    
    func login() async throws -> LoginResponse
    
}
    
class AuthRepository: AuthRepositoryProtocol {
    
    func login() async throws -> LoginResponse {
        guard let url = URL(string: "https://api.baubuddy.de/index.php/login") else {
            throw URLError(.badURL)
        }
        
        let requestBody: [String: Any] = [
            "username": "365",
            "password": "1"
        ] 
        let headers = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
            return LoginResponse(token: "", refreshToken: "")
        }
        
        guard let oauth = dictionary["oauth"] as? Dictionary<String, Any> else {
            return LoginResponse(token: "", refreshToken: "")
        }
        
        let accessToken = oauth["access_token"]
        let refreshToken = oauth["refresh_token"]
        let userOauth = LoginResponse(token: accessToken as? String ?? "", refreshToken: refreshToken as? String ?? "" )
        
        return userOauth
    }
    
}
