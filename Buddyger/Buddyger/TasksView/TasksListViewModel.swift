//
//  TasksListViewModel.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 2.12.24.
//

import Foundation
import Combine

protocol TasksListViewModelProtocol {
    
    /// Authenticates the user and fetches tasks.
    func authenticateAndFetchTasks()
    
    /// Filters tasks based on a query string.
    ///
    /// - Parameter query: The string used to filter tasks. If empty, all tasks are presented.
    func searchTasks(query: String)
    
    // A subject that holds the currently presented tasks and notifies observers of changes.
    var presentedTasks: CurrentValueSubject<[TaskModel], Never> { get }
}

class TasksListViewModel: TasksListViewModelProtocol {

    // MARK: - Properties
    private weak var delegate: TasksListViewModelDelegate?
    private var authRepo: AuthRepositoryProtocol
    private(set) var loginResponse: LoginResponse?
    private var tasksManagerRepository: TaskManagerRepositoryProtocol
    private var persistenceManager: CoreDataMangerProtocol
    private var tasks: [TaskModel] = []
    var presentedTasks = CurrentValueSubject<[TaskModel], Never>([])

    // MARK: - Initializer
    init(delegate: TasksListViewModelDelegate?,
         persistenceManager: CoreDataMangerProtocol,
         authRepo: AuthRepositoryProtocol,
         tasksManagerRepository: TaskManagerRepositoryProtocol) {
        
        self.authRepo = authRepo
        self.tasksManagerRepository = tasksManagerRepository
        self.delegate = delegate
        self.persistenceManager = persistenceManager
    }

    // MARK: - TasksListViewModelProtocol Methods
    func authenticateAndFetchTasks() {
        Task {
            if loginResponse == nil {
                await self.fetchAuthRespose()
            }
            self.fetchTasks()
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

    // MARK: - Private Methods
    private func fetchTasks() {
        Task {
            guard let loginResponse = loginResponse else {
                print(TasksListViewModelConstants.loginError)
                return
            }
            
            do {
                let tasks = try await tasksManagerRepository.fetchTasks(
                    token: loginResponse.token,
                    refreshToken: loginResponse.refreshToken
                )

                DispatchQueue.main.async {
                    self.saveTasksToCoreData(tasks: tasks)
                    self.tasks = tasks
                    self.presentedTasks.send(tasks)
                }
            } catch {
                DispatchQueue.main.async {
                    self.tasks = self.fetchTasksFromCoreData()
                    self.presentedTasks.send(self.tasks)
                }
                print("\(TasksListViewModelConstants.fetchTasksError)\(error)")
            }
        }
    }
    
    private func fetchAuthRespose() async {
        do {
            loginResponse = try await authRepo.login()
        } catch {
            print("\(TasksListViewModelConstants.authResponseError)\(error)")
        }
    }
    
    private func saveTasksToCoreData(tasks: [TaskModel]) {
        persistenceManager.saveTasksToCoreData(tasks: tasks)
    }

    private func fetchTasksFromCoreData() -> [TaskModel] {
        return persistenceManager.fetchTasksFromCoreData()
    }
}
