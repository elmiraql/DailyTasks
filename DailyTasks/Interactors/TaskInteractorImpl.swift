//
//  TaskInteractorImpl.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import Foundation
import CoreData

protocol TaskInteractor: AnyObject {
    func fetchTasks()
    func removeTask(with id: Int, completion: @escaping (Bool) -> Void)
}

class TaskInteractorImpl: TaskInteractor {
    
    var presenter: TaskPresenter!
    private let networkService = TasksNetworkService()
    
    func fetchTasks() {
        if isFirstLaunch() {
            DispatchQueue.global().async { [weak self] in
                self?.loadTasksFromAPI()
                self?.setFirstLaunchFlag()
            }
        } else {
            loadTasksFromCoreData()
        }
//        CoreDataService.shared.clearCoreData()
//        UserDefaults.standard.removeObject(forKey: "isFirstLaunch")
//        print(UserDefaults.standard.value(forKey: "isFirstLaunch"))
    }
    
    func loadTasksFromAPI(){
        networkService.fetchTasks { [weak self] tasks, error in
            if let error = error {return}
            guard let tasks = tasks else { return }
            self?.presenter.tasksFetched(tasks)
        }
    }
    
    func loadTasksFromCoreData() {
        var tasks = CoreDataService.shared.fetchTasksFromCoreData { tasks in
            self.presenter.tasksFetched(tasks)
        }
        
    }
    
    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isFirstLaunch")
    }
    
    private func setFirstLaunchFlag() {
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
    
    func removeTask(with id: Int, completion: @escaping (Bool) -> Void) {
        CoreDataService.shared.deleteTask(withId: id) { deleted in
            completion(deleted)
        }
    }
    
}
