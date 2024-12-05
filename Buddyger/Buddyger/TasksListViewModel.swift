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
    var presentedTasks: [TaskModel] { get }
}

class TasksListViewModel {
    
    private var tasks: [TaskModel] = []
    @Published var presentedTasks: [TaskModel] = []
    
    func fetchTasks() {
        Task {
            do {
                let request = try await AuthManager.shared.login()
                let tasks = try await NetworkManager.shared.fetchTasks(token: request
                    .token, refreshToken: request.refreshToken)
                
                
                
                DispatchQueue.main.async {
                    self.saveTasksToCoreData(tasks: tasks)
                    self.tasks = tasks
                    self.presentedTasks = tasks
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.tasks = self.fetchTasksFromCoreData()
                    self.presentedTasks = self.tasks
                }
                print("Error fetching tasks from API: \(error)")
            }
        }
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            presentedTasks = tasks
        } else {
            presentedTasks = tasks.filter { task in
                task.title?.localizedCaseInsensitiveContains(query) == true ||
                task.descriptionTask?.localizedCaseInsensitiveContains(query) == true
            }
        }
    }
    
    private func saveTasksToCoreData(tasks: [TaskModel]) {
        CoreDataManager.shared.saveTasksToCoreData(tasks: tasks)
    }
    
    private func fetchTasksFromCoreData() -> [TaskModel] {
        return CoreDataManager.shared.fetchTasksFromCoreData()
    }
    
}
