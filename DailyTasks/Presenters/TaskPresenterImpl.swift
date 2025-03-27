//
//  TaskPresenterImpl.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import Foundation

protocol TaskPresenter: AnyObject {
    func loadTasks()
    func tasksFetched(_ tasks: [MyTask])
    func numberOfTasks() -> Int
    func task(at indexPath: Int) -> MyTask
    func didSelectTask(at index: Int)
    func filterTasks(by searchText: String)
    func allTasks() -> [MyTask]
    func removeTask(with id: Int)
    func addNewTask()
    var router: TaskRouter! { get set }
}

class TaskPresenterImpl: TaskPresenter {
    
    weak var view: TaskView?
    var interactor: TaskInteractor!
    var router: TaskRouter!
    private var tasks: [MyTask] = []
    var filteredTasks: [MyTask] = []
    var isSearching = false
    
    func loadTasks() {
        self.interactor.fetchTasks()
    }
    
    func tasksFetched(_ tasks: [MyTask]) {
        self.tasks = tasks
        self.filteredTasks = tasks
        DispatchQueue.main.async {
            self.view?.displayTasks(tasks)
        }
    }
    
    func numberOfTasks() -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }
    
    func task(at index: Int) -> MyTask {
        return isSearching ? filteredTasks[index] : tasks[index]
    }
    
    func didSelectTask(at index: Int) {
        let task = isSearching ? filteredTasks[index] : tasks[index]
        router.navigateToTaskDetail(for: task, taskType: .edit)
    }
    
    func removeTask(with id: Int) {
        interactor.removeTask(with: id) { [weak self] deleted in
            guard let self = self else { return }
            
            if deleted {
                self.tasks.removeAll { $0.id == id }
                if self.isSearching {
                    self.filteredTasks.removeAll { $0.id == id }
                }
            }
            
            DispatchQueue.main.async {
                self.view?.displayTasks(self.isSearching ? self.filteredTasks : self.tasks)
            }
        }
                
    }
    
    func filterTasks(by searchText: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            self?.isSearching = !searchText.isEmpty
            
            if self?.isSearching == true {
                self?.filteredTasks = self?.tasks.filter { $0.todo?.localizedCaseInsensitiveContains(searchText) == true } ?? []
            } else {
                self?.filteredTasks = self?.tasks ?? []
            }
            
            DispatchQueue.main.async {
                self?.view?.displayTasks(self?.filteredTasks ?? [])
            }
        }
    }
    
    func allTasks() -> [MyTask] {
        return tasks
    }
    
    func addNewTask() {
        let task = MyTask()
        router.navigateToTaskDetail(for: task, taskType: .new)
    }
}
