
//  ListToDoInteractorProtocol.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.


protocol ListTodoInteractorInputProtocol: AnyObject {
    var presenter: ListTodoInteractorOutputProtocol? { get set }
    var coreDataStack: CoreDataStack { get set }
    
    func retrieveTodos()
    func saveTodo(_ todo: TodoItem)
    func deleteTodo(_ todo: TodoItem)
    func searchTodos(with query: String)
    func loadTodosFromAPI()
}

protocol ListTodoInteractorOutputProtocol: AnyObject {
    func didRetrieveTodos(_ todos: [TodoItem])
    func didSaveTodo(_ todo: TodoItem)
    func didDeleteTodo(_ todo: TodoItem)
    func onError(_ message: String)
    func onSuccess(_ message: String)
}

