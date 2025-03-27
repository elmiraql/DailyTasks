//
//  Task+CoreDataProperties.swift
//  DailyTasks
//
//  Created by Elmira Qurbanova on 23.03.25.
//
//

import Foundation
import CoreData


extension SomeTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SomeTask> {
        return NSFetchRequest<SomeTask>(entityName: "SomeTask")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var completed: Bool
    @NSManaged public var todo: String?
    @NSManaged public var taskText: String?
}

extension SomeTask : Identifiable {

}
