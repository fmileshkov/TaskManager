//
//  MockClasses.swift
//  BuddygerTests
//
//  Created by Filip Mileshkov on 10.12.24.
//

import XCTest
@testable import Buddyger

enum MockSuccesCase {
    case success
    case fail
}

enum MockNetWorkingError: Error {
    case failed
}

class MockCoreDataManager: CoreDataMangerProtocol {
    private var mockTasks: [TaskModel] = []
    var successType: MockSuccesCase

    init(successType: MockSuccesCase = .success) {
            self.successType = successType
        }
    
    func saveTasksToCoreData(tasks: [TaskModel]) {
        switch successType {
        case .success:
            mockTasks = tasks
        case .fail:
            mockTasks = []
        }
        
    }

    func fetchTasksFromCoreData() -> [TaskModel] {
        switch successType {
        case .success:
            return mockTasks
        case .fail:
            return []
        }
        
    }
}

class MockTaskManagerRepository: TaskManagerRepositoryProtocol {
    
    private var mockTasks: [TaskModel] = []
    var successType: MockSuccesCase

    init(successType: MockSuccesCase = .success) {
            self.successType = successType
        }
    
    func fetchTasks(token: String, refreshToken: String) async throws -> [Buddyger.TaskModel] {
        switch successType {
        case .success:
            mockTasks = [TaskModel(task: "Task1", title: token, description: refreshToken, colorCode: ".red")]
            return mockTasks
        case .fail:
            throw MockNetWorkingError.failed
        }
    }
    
}

class MockAuthRepository: AuthRepositoryProtocol {
    
    var successType: MockSuccesCase
    private var tokenString: String
    private var refreshTokenString: String
    
    init(successType: MockSuccesCase = .success,
         tokenString: String,
         refreshTokenString: String) {
        self.successType = successType
        self.refreshTokenString = refreshTokenString
        self.tokenString = tokenString
    }
    
    func login() async throws -> Buddyger.LoginResponse {
        switch successType {
        case .success:
            return LoginResponse(token: tokenString, refreshToken: refreshTokenString)
        case .fail:
            throw MockNetWorkingError.failed
        }
    }
    
}
