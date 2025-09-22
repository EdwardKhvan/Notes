//
//  ListToDoPresenterProtocol.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

protocol ListTodoPresenterProtocol: AnyObject {
    var view: ListTodoViewProtocol? { get set }
    var interactor: ListTodoInteractorInputProtocol? { get set }
    var router: ListTodoRouterProtocol? { get set }
    
    func viewDidLoad()
    func addTodo(_ todo: TodoItem)
    func editTodo(_ todo: TodoItem)
    func deleteTodo(_ todo: TodoItem)
    func searchTodos(with query: String)
    func loadTodosFromAPI()
}
