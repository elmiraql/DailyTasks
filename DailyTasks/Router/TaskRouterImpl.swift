//
//  TaskRouter.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import UIKit

protocol TaskRouter: AnyObject {
    func navigateToTaskDetail(for task: MyTask, taskType: TaskType)
}

class TaskRouterImpl: TaskRouter {
    
    weak var viewController: UIViewController?
    
    func navigateToTaskDetail(for task: MyTask, taskType: TaskType) {
        let detailViewController = TaskDetailViewController(type: taskType)
        let presenter = TaskDetailsPresenterImpl()
        detailViewController.presenter = presenter
        presenter.view = detailViewController
        let interactor = TaskDetailsInteractorImpl()
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        detailViewController.task = task
        detailViewController.delegate = viewController as? TaskViewController
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}
