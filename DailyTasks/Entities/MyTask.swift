//
//  MyTask.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//

import Foundation

struct MyTasks: Codable {
    var todos: [MyTask]?
    var total: Int?
    var skip: Int?
}

struct MyTask: Codable {
    var userId: Int?
    var id: Int?
    var completed: Bool?
    var todo: String?
    var taskText: String?
}
