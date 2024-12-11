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
    
    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockCoreDataManager(successType: .success)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .success)
        mockAuthRepository = MockAuthRepository(successType: .success,
                                                tokenString: "Test",
                                                refreshTokenString: "TEST")
        viewModel = TasksListViewModel(
            delegate: TasksListViewCoordinator(navController: UINavigationController()),
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
        var mockTasks: [TaskModel] = []
        
        do {
            let request = try await mockAuthRepository.login()
            let tasks = try await mockTaskManagerRepository.fetchTasks(token: request.token, refreshToken: request.refreshToken)
            mockTasks = tasks
            mockPersistenceManager.saveTasksToCoreData(tasks: tasks)
        } catch {
            print(MockNetWorkingError.failed)
        }
        
        // When
        Task {
            viewModel.fetchTasks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expectation.fulfill() //
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
        var mockTasks: [TaskModel] = []
        
        mockPersistenceManager = MockCoreDataManager(successType: .fail)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .fail)
        mockAuthRepository = MockAuthRepository(successType: .fail,
                                                tokenString: "token",
                                                refreshTokenString: "refreshToken")
        viewModel = await TasksListViewModel(
            delegate: TasksListViewCoordinator(navController: UINavigationController()),
            persistenceManager: mockPersistenceManager,
            authRepo: mockAuthRepository,
            tasksManagerRepository: mockTaskManagerRepository
        )
        
        do {
            let request = try await mockAuthRepository.login()
            let tasks = try await mockTaskManagerRepository.fetchTasks(token: request.token, refreshToken: request.refreshToken)
            mockTasks = tasks
            mockPersistenceManager.saveTasksToCoreData(tasks: tasks)
        } catch {
            print(MockNetWorkingError.failed)
        }
        
        // When
        Task {
            viewModel.fetchTasks()
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
        var mockTasks: [TaskModel] = []
        
        do {
            let request = try await mockAuthRepository.login()
            let tasks = try await mockTaskManagerRepository.fetchTasks(token: request.token, refreshToken: request.refreshToken)
            mockTasks = tasks
            mockPersistenceManager.saveTasksToCoreData(tasks: tasks)
        } catch {
            print(MockNetWorkingError.failed)
        }
        
        Task {
            viewModel.fetchTasks()
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
        var mockTasks: [TaskModel] = []
        
        mockPersistenceManager = MockCoreDataManager(successType: .fail)
        mockTaskManagerRepository = MockTaskManagerRepository(successType: .fail)
        mockAuthRepository = MockAuthRepository(successType: .fail,
                                                tokenString: "token",
                                                refreshTokenString: "refreshToken")
        viewModel = await TasksListViewModel(
            delegate: TasksListViewCoordinator(navController: UINavigationController()),
            persistenceManager: mockPersistenceManager,
            authRepo: mockAuthRepository,
            tasksManagerRepository: mockTaskManagerRepository
        )
        
        do {
            let request = try await mockAuthRepository.login()
            let tasks = try await mockTaskManagerRepository.fetchTasks(token: request.token, refreshToken: request.refreshToken)
            mockTasks = tasks
            mockPersistenceManager.saveTasksToCoreData(tasks: tasks)
        } catch {
            print(MockNetWorkingError.failed)
        }
        
        Task {
            viewModel.fetchTasks()
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
