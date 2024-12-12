//
//  NetworkManager.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 1.12.24.
//

import Foundation

protocol TaskManagerRepositoryProtocol: AnyObject {
    /// Fetches a list of tasks using the provided authentication tokens.
    ///
    /// - Parameters:
    ///   - token: A valid access token for authentication.
    ///   - refreshToken: A token used to refresh the access token if needed.
    /// - Returns: An array of `TaskModel` objects.
    /// - Throws: An error if the fetch operation fails, including `APIError` for specific issues.
    func fetchTasks(token: String, refreshToken: String) async throws -> [TaskModel]
}

class TaskManagerRepository: TaskManagerRepositoryProtocol {
    
    // MARK: - Methods
    func fetchTasks(token: String, refreshToken: String) async throws -> [TaskModel] {
        
        guard let url = URL(string: APIConstants.baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(APIConstants.bearerPrefix) \(token)", forHTTPHeaderField: APIConstants.authorizationHeader)
        request.addValue(APIConstants.contentTypeJSON, forHTTPHeaderField: APIConstants.contentTypeHeader)
        request.httpBody = Data()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let tasks = try JSONDecoder().decode([TaskModel].self, from: data)
            return tasks
            
        case 401:
            throw APIError.unauthorized
            
        default:
            throw APIError.invalidResponse
        }
    }
}
