//
//  ListToDoPresenter.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import Foundation

class ListTodoPresenter: ListTodoPresenterProtocol {
    weak var view: ListTodoViewProtocol?
    var interactor: ListTodoInteractorInputProtocol?
    var router: ListTodoRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        
        let hasSavedTodos = UserDefaults.standard.array(forKey: "savedTodos") != nil
        
        if hasSavedTodos {
            print("Loading saved todos from UserDefaults")
            interactor?.retrieveTodos()
        } else {
            print("No saved todos found, loading from JSON")
            loadTodosFromAPI()
        }
    }
    
    func addTodo(_ todo: TodoItem) {
        interactor?.saveTodo(todo)
    }
    
    func editTodo(_ todo: TodoItem) {
        interactor?.saveTodo(todo)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        interactor?.deleteTodo(todo)
    }
    
    func searchTodos(with query: String) {
        interactor?.searchTodos(with: query)
    }
    
    func loadTodosFromAPI() {
        view?.showLoading()
        interactor?.loadTodosFromAPI()
    }
}

extension ListTodoPresenter: ListTodoInteractorOutputProtocol {
    func didRetrieveTodos(_ todos: [TodoItem]) {
        view?.hideLoading()
        view?.showTodos(todos)
    }
    
    func didSaveTodo(_ todo: TodoItem) {
        interactor?.retrieveTodos()
    }
    
    func didDeleteTodo(_ todo: TodoItem) {
        interactor?.retrieveTodos()
    }
    
    func onError(_ message: String) {
        view?.hideLoading()
        view?.showError(message)
    }
    
    func onSuccess(_ message: String) {
        view?.hideLoading()
        view?.showSuccess(message)
    }
}
