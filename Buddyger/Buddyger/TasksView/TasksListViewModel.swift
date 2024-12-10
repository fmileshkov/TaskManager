//
//  TasksListViewModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 2.12.24.
//

import Foundation
import Combine

protocol TasksListViewModelProtocol {
    func fetchTasks()
    func searchTasks(query: String)
    var presentedTasks: CurrentValueSubject<[TaskModel], Never> { get }
}

class TasksListViewModel: TasksListViewModelProtocol {
    
    private var tasks: [TaskModel] = []
    private weak var coordinatorDelegate: TasksListViewCoordinatorDelegate?
    private var persistenceManager: CoreDataManager
    private var authRepo: AuthRepository
    var presentedTasks = CurrentValueSubject<[TaskModel], Never>([])
    
    init(coordinatorDelegate: TasksListViewCoordinatorDelegate?,
         persistenceManager: CoreDataManager,
         authRepo: AuthRepository) {
        
        self.coordinatorDelegate = coordinatorDelegate
        self.persistenceManager = persistenceManager
        self.authRepo = authRepo
    }
    
    func fetchTasks() {
        Task {
            do {
                let request = try await authRepo.login()
                let tasks = try await NetworkManager.shared.fetchTasks(token: request
                    .token, refreshToken: request.refreshToken)

                DispatchQueue.main.async {
                    self.saveTasksToCoreData(tasks: tasks)
                    self.tasks = tasks
                    self.presentedTasks.send(tasks)
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.tasks = self.fetchTasksFromCoreData()
                    self.presentedTasks.send(self.tasks)
                }
                print("Error fetching tasks from API: \(error)")
            }
        }
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            presentedTasks.send(tasks)  // Send all tasks if the query is empty
        } else {
            let filteredTasks = tasks.filter { task in
                task.title?.localizedCaseInsensitiveContains(query) == true ||
                task.description?.localizedCaseInsensitiveContains(query) == true
            }
            presentedTasks.send(filteredTasks)  // Send the filtered tasks
        }
    }
    
    private func saveTasksToCoreData(tasks: [TaskModel]) {
        persistenceManager.saveTasksToCoreData(tasks: tasks)
    }
    
    private func fetchTasksFromCoreData() -> [TaskModel] {
        return persistenceManager.fetchTasksFromCoreData()
    }
    
}
