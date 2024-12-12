//
//  BuddygerTests.swift
//  BuddygerTests
//
//  Created by Filip Mileshkov on 11.12.24.
//

import XCTest
@testable import Buddyger

final class TasksListViewModelTests: XCTestCase {
    
    var viewModel: TasksListViewModelProtocol!
    var mockPersistenceManager: CoreDataMangerProtocol!
    var mockTaskManagerRepository: TaskManagerRepositoryProtocol!
    var mockAuthRepository: AuthRepositoryProtocol!
    
    override func setUp() async throws {
        try await super.setUp()
        mockPersistenceManager = MockCoreDataManager(successType: .success)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .success)
        mockAuthRepository = MockAuthRepository(successType: .success)
        
        viewModel = TasksListViewModel(
            delegate: MockTasksListViewCoordinator(),
            persistenceManager: mockPersistenceManager,
            authRepo: mockAuthRepository,
            tasksManagerRepository: mockTaskManagerRepository
        )
        
    }
    
    override func tearDown() {
        mockPersistenceManager = nil
        mockTaskManagerRepository = nil
        mockAuthRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchTasksHappyCase() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch tasks updates presentedTasks")
        let mockTasks: [TaskModel] = [TaskModel(task: "Task",
                                               title: "Test",
                                                description: "TEST",
                                               colorCode: "red")]
        
        // When
        Task {
            viewModel.authenticateAndFetchTasks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.presentedTasks.value, mockTasks)
        XCTAssertNotEqual(viewModel.presentedTasks.value, [])
    }

    func testFetchTasksFailureCase() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch tasks falls back to Core Data")
        let mockTasks: [TaskModel] = []
        
        mockPersistenceManager = MockCoreDataManager(successType: .fail)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .fail)
        mockAuthRepository = MockAuthRepository(successType: .fail)

        viewModel = TasksListViewModel(
            delegate: MockTasksListViewCoordinator(),
            persistenceManager: mockPersistenceManager,
            authRepo: mockAuthRepository,
            tasksManagerRepository: mockTaskManagerRepository)
        
        // When
        Task {
            viewModel.authenticateAndFetchTasks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.presentedTasks.value, mockTasks)
        XCTAssertEqual(viewModel.presentedTasks.value, [])
    }
    
    func testsearchTasksSuccessCase() async {
        
        // Given
        let expectation = XCTestExpectation(description: "Fetch tasks falls back to Core Data")
        let mockTasks: [TaskModel] = [TaskModel(task: "Task",
                                               title: "Test",
                                                description: "TEST",
                                               colorCode: "red")]
        
        Task {
            viewModel.authenticateAndFetchTasks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)

        // When
        viewModel.searchTasks(query: "Test")
        
        // Then
        XCTAssertEqual(viewModel.presentedTasks.value, mockTasks)
        XCTAssertNotEqual(viewModel.presentedTasks.value, [])
    }
    
    func testsearchTasksFailureCase() async {
        // Given
        let expectation = XCTestExpectation(description: "Fetch tasks falls back to Core Data")
        let mockTasks: [TaskModel] = []
        
        mockPersistenceManager = MockCoreDataManager(successType: .fail)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .fail)
        mockAuthRepository = MockAuthRepository(successType: .fail)
        
        viewModel = TasksListViewModel(
            delegate: MockTasksListViewCoordinator(),
            persistenceManager: mockPersistenceManager,
            authRepo: mockAuthRepository,
            tasksManagerRepository: mockTaskManagerRepository)
        
        Task {
            viewModel.authenticateAndFetchTasks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)

        // When
        viewModel.searchTasks(query: "")
        
        // Then
        XCTAssertEqual(viewModel.presentedTasks.value, mockTasks)
        XCTAssertEqual(viewModel.presentedTasks.value, [])
    }
    
}
