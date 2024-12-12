//
//  CoreDataManger.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataMangerProtocol {
    /// Saves an array of tasks to Core Data.
    ///
    /// - Parameter tasks: An array of `TaskModel` objects to be saved.
    func saveTasksToCoreData(tasks: [TaskModel])
    
    /// Fetches all tasks from Core Data.
    ///
    /// - Returns: An array of `TaskModel` objects retrieved from Core Data.
    func fetchTasksFromCoreData() -> [TaskModel]
}

class CoreDataManager: CoreDataMangerProtocol {
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataConstants.containerName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Context
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    func saveTasksToCoreData(tasks: [TaskModel]) {
        let context = viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear old tasks: \(error.localizedDescription)")
        }
        
        for task in tasks {
            let taskEntity = TaskEntity(context: context)
            taskEntity.task = task.task
            taskEntity.title = task.title
            taskEntity.descriptionTask = task.description
            taskEntity.colorCode = task.colorCode
        }
        
        do {
            try context.save()
            print("Tasks saved successfully.")
        } catch {
            print("Failed to save tasks: \(error.localizedDescription)")
        }
    }
    
    func fetchTasksFromCoreData() -> [TaskModel] {
        let context = viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            print("Fetched tasks from Core Data: \(taskEntities.count) tasks found.")
            return taskEntities.map { taskEntity in
                TaskModel(
                    task: taskEntity.task,
                    title: taskEntity.title,
                    description: taskEntity.descriptionTask,
                    colorCode: taskEntity.colorCode
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
}
