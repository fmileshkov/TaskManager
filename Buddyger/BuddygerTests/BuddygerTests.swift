//
//  BuddygerTests.swift
//  BuddygerTests
//
//  Created by Filip Mileshkov on 30.11.24.
//

import XCTest
@testable import Buddyger

final class TasksListViewModelTests: XCTestCase {
    
    var viewModel: TasksListViewModel!
    var mockPersistenceManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockCoreDataManager()
        viewModel = TasksListViewModel(
            coordinatorDelegate: nil,
            persistenceManager: mockPersistenceManager,
            authRepo: AuthRepository()
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistenceManager = nil
        super.tearDown()
    }

    func testFetchTasks_HappyPath() {
        // Arrange
        let mockTasks = [
            TaskModel(task: "Task1", title: "Buy Groceries", description: "Milk, Bread, Eggs", colorCode: ".red"),
            TaskModel(task: "Task2", title: "Read Book", description: "Read Swift Programming", colorCode: ".blue"),
            TaskModel(task: "Task3", title: "Workout", description: "Morning Yoga Session", colorCode: ".green")
        ]
        
        viewModel.presentedTasks = mockTasks
        mockPersistenceManager.saveTasksToCoreData(tasks: mockTasks)

        // Act
        viewModel.fetchTasks()
        viewModel.searchTasks(query: "")
        
        XCTAssertEqual(viewModel.presentedTasks.count, 3)
        XCTAssertEqual(viewModel.presentedTasks.first?.title, "Read")
    }

}
