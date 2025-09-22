//
//  TodoItemEntity+CoreData.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import Foundation
import CoreData

@objc(TodoItemEntity)
public class TodoItemEntity: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var todoDescription: String
    @NSManaged public var createdAt: Date
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int32
}

extension TodoItemEntity {
    func toTodoItem() -> TodoItem {
        return TodoItem(
            id: self.id,
            title: self.title,
            description: self.todoDescription,
            createdAt: self.createdAt,
            completed: self.completed,
            userId: self.userId
        )
    }
    
    func update(from todoItem: TodoItem) {
        self.id = todoItem.id
        self.title = todoItem.title
        self.todoDescription = todoItem.description
        self.createdAt = todoItem.createdAt
        self.completed = todoItem.completed
        self.userId = todoItem.userId
    }
}
