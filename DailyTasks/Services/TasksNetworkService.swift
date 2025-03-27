//
//  TasksNetworkService.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import Foundation

class TasksNetworkService {
    
    func fetchTasks(completion: @escaping([MyTask]?, Error?) -> Void) {
        let urlString = "https://dummyjson.com/todos"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1))
                return
            }
            do {
                let tasks = try JSONDecoder().decode(MyTasks.self, from: data)
                completion(tasks.todos, nil)
                if let tasks = tasks.todos {
                    DispatchQueue.main.async {
                        CoreDataService.shared.saveTasksToCoreData(tasks: tasks) { success in
//                            completion(success)
                        }
                    }
                   
                }

            } catch {
                completion(nil, error)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
