//
//  ViewController.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import UIKit

protocol TaskView: AnyObject {
    func displayTasks(_ tasks: [MyTask])
}

class TaskViewController: UIViewController, TaskView, TaskDetailDelegate {
    
    var mainView: TaskMainView!
    var presenter: TaskPresenter!
    
    var footerView = TableFooterView()
    
    func displayTasks(_ tasks: [MyTask]) {
        mainView.tableView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        let contentView = TaskMainView()
        self.view = contentView
        mainView = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = TaskRouterImpl()
        router.viewController = self
        presenter.router = router
        
        presenter.loadTasks()
        setupTableView()
        mainView.searchBar.delegate = self
        title = "Задачи"
    }
    
    func setupTableView(){
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(MyTaskCell.self, forCellReuseIdentifier: "TableCellId")
        
        view.addSubview(footerView)
        footerView.label.text = "\(presenter.numberOfTasks()) задач"
        footerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        footerView.addTask = { [weak self] in
            self?.presenter.addNewTask()
        }
    }
    
    func didUpdateTask() {
        presenter.loadTasks()
    }
    
    
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellId") as? MyTaskCell else { return UITableViewCell()}
        let task = presenter.task(at: indexPath.row)
        cell.task = task
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.didSelectTask(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = presenter.task(at: indexPath.row)
        return (task.todo?.description.height(withConstrainedWidth: tableView.frame.width - 32, font: UIFont.systemFont(ofSize: 16)) ?? 0) + 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = presenter.task(at: indexPath.row)
            presenter.removeTask(with: task.id ?? 0)
        }
    }

}

extension TaskViewController: MyTaskCellDelegate {
    func didToggleTaskCompletion(cell: MyTaskCell, isCompleted: Bool) {
        guard let task = cell.task else { return }
        CoreDataService.shared.updateTaskInCoreData(task: task) { updated in }
    }
}

extension TaskViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterTasks(by: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter.filterTasks(by: "")
    }
}
