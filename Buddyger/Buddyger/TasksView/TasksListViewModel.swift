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
    private weak var delegate: TasksListViewModelDelegate?
    private var persistenceManager: CoreDataMangerProtocol
    private var authRepo: AuthRepositoryProtocol
    private var tasksManagerRepository: TaskManagerRepositoryProtocol
    var presentedTasks = CurrentValueSubject<[TaskModel], Never>([])
    
    init(delegate: TasksListViewModelDelegate?,
         persistenceManager: CoreDataMangerProtocol,
         authRepo: AuthRepositoryProtocol,
         tasksManagerRepository: TaskManagerRepositoryProtocol) {
        
        self.tasksManagerRepository = tasksManagerRepository
        self.delegate = delegate
        self.persistenceManager = persistenceManager
        self.authRepo = authRepo
    }
    
    func fetchTasks() {
        Task {
            do {
                let request = try await authRepo.login()
                let tasks = try await tasksManagerRepository.fetchTasks(token: request
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
            presentedTasks.send(tasks)
        } else {
            let filteredTasks = tasks.filter { task in
                task.title?.localizedCaseInsensitiveContains(query) == true ||
                task.description?.localizedCaseInsensitiveContains(query) == true
            }
            presentedTasks.send(filteredTasks)
        }
    }
    
    private func saveTasksToCoreData(tasks: [TaskModel]) {
        persistenceManager.saveTasksToCoreData(tasks: tasks)
    }
    
    private func fetchTasksFromCoreData() -> [TaskModel] {
        return persistenceManager.fetchTasksFromCoreData()
    }
    
}
