//
//  CoreDataService.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}

    func saveTasksToCoreData(tasks: [MyTask], completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {completion(false)
            return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        DispatchQueue.global().async {
            for task in tasks {
                let coreDataTask = SomeTask(context: context)
                coreDataTask.id = Int16(Int64(task.id ?? 0))
                coreDataTask.todo = task.todo
                coreDataTask.completed = task.completed ?? false
                coreDataTask.userId = Int16(Int64(task.userId ?? 0))
                coreDataTask.taskText = task.taskText ?? ""
            }
            
            do {
                try context.save()
                print("tasks saved")
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("failed to save tasks: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func updateTaskInCoreData(task: MyTask, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SomeTask> = SomeTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id ?? 0)
        
        DispatchQueue.global().async {
            do {
                let results = try context.fetch(fetchRequest)
                if let existingTask = results.first {
                    existingTask.taskText = task.taskText
                    existingTask.completed = task.completed ?? false
                    existingTask.userId = Int16(Int64(task.userId ?? 0))
                    existingTask.todo = task.todo ?? ""
                    try context.save()
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            } catch {
                print("failed to update task: \(error.localizedDescription)")
            }
            
        }
      
    }
    
    func fetchTasksFromCoreData(completion: @escaping ([MyTask]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SomeTask> = SomeTask.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        DispatchQueue.global().async {
            do {
                let coreDataTasks = try context.fetch(fetchRequest)
                let tasks = coreDataTasks.map { coreDataTask in
                    return MyTask(userId: Int(coreDataTask.userId),
                                  id: Int(coreDataTask.id),
                                  completed: coreDataTask.completed,
                                  todo: coreDataTask.todo ?? "",
                                  taskText: coreDataTask.taskText ?? "")
                }
                
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func deleteTask(withId id: Int, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<SomeTask> = SomeTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        DispatchQueue.global().async {
            do {
                let results = try context.fetch(fetchRequest)
                if let taskToDelete = results.first {
                    context.delete(taskToDelete)
                    
                    try context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func addTaskToCoreData(task: MyTask, completion: @escaping (Bool) -> Void) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               completion(false)
               return
           }
           let context = appDelegate.persistentContainer.viewContext
           
           DispatchQueue.global().async {
               let coreDataTask = SomeTask(context: context)
               coreDataTask.id = Int16(task.id ?? 0)
               coreDataTask.todo = task.todo
               coreDataTask.completed = task.completed ?? false
               coreDataTask.userId = Int16(Int64(task.userId ?? 0))
               coreDataTask.taskText = task.taskText ?? ""

               do {
                   try context.save()
                   print("task saved")
                   DispatchQueue.main.async {
                       completion(true)
                   }
               } catch {
                   print("failed to save task: \(error.localizedDescription)")
                   DispatchQueue.main.async {
                       completion(false)
                   }
               }
           }
       }
    
    func clearCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entityNames = ["SomeTask"]
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
            } catch {
                print("failed to delete data from \(entityName): \(error.localizedDescription)")
            }
        }
        
        do {
            try context.save()
            print("successfully cleared core data")
        } catch {
            print("failed to save context after clearing: \(error.localizedDescription)")
        }
    }
}
