//
//  ToDoItem.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import Foundation

struct TodoItem {
    let id: Int32
    var title: String
    var description: String
    var createdAt: Date
    var completed: Bool
    var userId: Int32
    
    init(id: Int32, title: String, description: String, createdAt: Date, completed: Bool, userId: Int32) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.completed = completed
        self.userId = userId
    }
    
    init?(from json: [String: Any]) {
        guard let id = json["id"] as? Int32,
              let title = json["todo"] as? String,
              let completed = json["completed"] as? Bool,
              let userId = json["userId"] as? Int32 else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = ""
        self.createdAt = Date()
        self.completed = completed
        self.userId = userId
    }
}

extension TodoItem: Equatable {
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
