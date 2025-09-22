//
//  ListTodoRouterProtocol.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

protocol ListTodoRouterProtocol: AnyObject {
    func createModule(coreDataStack: CoreDataStack) -> UIViewController
    func presentAddTodoScreen(from view: ListTodoViewProtocol, delegate: AddTodoDelegate)
    func presentEditTodoScreen(from view: ListTodoViewProtocol, todo: TodoItem, delegate: EditTodoDelegate)
}

protocol AddTodoDelegate: AnyObject {
    func didAddTodo(_ todo: TodoItem)
}

protocol EditTodoDelegate: AnyObject {
    func didEditTodo(_ todo: TodoItem)
}
