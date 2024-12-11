//
//  NetworkManager.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 1.12.24.
//

import Foundation

protocol TaskManagerRepositoryProtocol: AnyObject {
    
    func fetchTasks(token: String, refreshToken: String) async throws -> [TaskModel]
}

class TaskManagerRepository: TaskManagerRepositoryProtocol {
    
    func fetchTasks(token: String, refreshToken: String) async throws -> [TaskModel] {
        
        guard let url = URL(string: "https://api.baubuddy.de/dev/index.php/v1/tasks/select") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
