//
//  ListToDoViewProtocol.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import Foundation

protocol ListTodoViewProtocol: AnyObject {
    var presenter: ListTodoPresenterProtocol? { get set }
    func showTodos(_ todos: [TodoItem])
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func showLoading()
    func hideLoading()
}
