//
//  ToDoList+CoreDataProperties.swift
//  coreDataTodo
//
//  Created by Hari on 29/03/23.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoList : Identifiable {

}
