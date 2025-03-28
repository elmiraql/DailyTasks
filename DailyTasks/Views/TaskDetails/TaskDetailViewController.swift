//
//  TaskDetailViewController.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 24.03.25.
//

import UIKit

protocol TaskDetailDelegate: AnyObject {
    func didUpdateTask()
}

enum TaskType {
    case new
    case edit
}

protocol TaskDetailsViewProtocol: AnyObject {
    func displayDate(_ date: String)
}

class TaskDetailViewController: UIViewController, TaskDetailsViewProtocol {
   
    var presenter: TaskDetailsPresenter!
    var task: MyTask?
    var mainView: TaskDetailView!
    private var initialTaskTodo: String?
    private var initialTitle: String?
    weak var delegate: TaskDetailDelegate?
    var taskType: TaskType
    
    init(type: TaskType) {
        self.taskType = type
        super.init(nibName: nil, bundle: nil) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let contentView = TaskDetailView()
        view = contentView
        mainView = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.fetchDate()

        if let task = task {
            mainView.setTitleText(task.todo)
            mainView.descTextView.text = task.taskText
            initialTaskTodo = task.taskText
            initialTitle = task.todo
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        switch taskType {
        case .new:
            saveNewTask()
        case .edit:
            updateTask()
        }
    }
    
    func displayDate(_ date: String) {
        mainView.dateLabel.text = date
    }
    
    func updateTask() {
        guard let newText = mainView.descTextView.text, !newText.isEmpty else { return }
        guard let titleText = mainView.title.text, !titleText.isEmpty else { return }
        let taskToUpdate = MyTask(userId: task?.userId, id: task?.id, completed: task?.completed, todo: titleText, taskText: newText)
        if newText != initialTaskTodo || titleText != initialTitle {
            presenter.updateTask(task: taskToUpdate) { updated in
                if updated {
                    self.delegate?.didUpdateTask()
                }
            }
           
        }
    }
    
    func saveNewTask() {
        guard let titleText = mainView.title.text, !titleText.isEmpty else { return }
        guard let todoText = mainView.descTextView.text else { return }

        let userId = 1
        let id = Int16.random(in: 0...Int16.max)
        
        let taskToCreate = MyTask(userId: userId, id: Int(id), completed: false, todo: titleText, taskText: todoText)
        
        presenter.saveNewTask(task: taskToCreate) { created in
            if created {
                print("task created successfully")
                self.delegate?.didUpdateTask()
            }
        }

    }
    
}
