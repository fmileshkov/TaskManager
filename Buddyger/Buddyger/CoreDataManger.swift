//
//  CoreDataManger.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 3.12.24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func saveTasksToCoreData(tasks: [TaskModel]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
            taskEntity.descriptionTask = task.descriptionTask
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            print("Fetched tasks from Core Data: \(taskEntities.count) tasks found.")
            return taskEntities.map { taskEntity in
                TaskModel(
                    task: taskEntity.task,
                    title: taskEntity.title,
                    descriptionTask: taskEntity.descriptionTask,
                    colorCode: taskEntity.colorCode
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }
    
}
