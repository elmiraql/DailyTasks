//
//  TaskDetailsPresenter.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 26.03.25.
//

import Foundation

protocol TaskDetailsPresenter: AnyObject {
    func fetchDate()
    func updateTask(task: MyTask, completion: @escaping (Bool) -> Void)
    func saveNewTask(task: MyTask, completion: @escaping (Bool) -> Void)
}

class TaskDetailsPresenterImpl: TaskDetailsPresenter {
   
    
    
    weak var view: TaskDetailsViewProtocol?
    var interactor: TaskDetailsInteractor!
    var router: TaskRouter!
    
    func fetchDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = dateFormatter.string(from: currentDate)
        self.view?.displayDate(today)
    }
    
    func updateTask(task: MyTask, completion: @escaping (Bool) -> Void) {
        CoreDataService.shared.updateTaskInCoreData(task: task) { updated in
            if updated {
                completion(true)
            } else {
                completion(false) 
            }
        }
    }
    
    func saveNewTask(task: MyTask, completion: @escaping (Bool) -> Void) {
        CoreDataService.shared.addTaskToCoreData(task: task) { success in
            if success {
                print("task successfully added!")
                completion(success)
            } else {
                print("failed to add task.")
            }
        }
    }
}
