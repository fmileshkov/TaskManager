//
//  MockClasses.swift
//  BuddygerTests
//
//  Created by Filip Mileshkov on 10.12.24.
//

import XCTest
@testable import Buddyger

class MockCoreDataManager: CoreDataManager {
    private var mockTasks: [TaskModel] = []

    override func saveTasksToCoreData(tasks: [TaskModel]) {
        mockTasks = tasks
    }

    override func fetchTasksFromCoreData() -> [TaskModel] {
        return mockTasks
    }
}
