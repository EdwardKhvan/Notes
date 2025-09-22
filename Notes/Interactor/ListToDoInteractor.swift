//
//  ListToDoInteractor.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import Foundation

class ListTodoInteractor: ListTodoInteractorInputProtocol {
    weak var presenter: ListTodoInteractorOutputProtocol?
    var coreDataStack: CoreDataStack
    
    private var todos: [TodoItem] = []
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func retrieveTodos() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.loadTodosFromUserDefaults()
            
            print("Retrieving todos: \(self.todos.count) items")
            self.presenter?.didRetrieveTodos(self.todos)
        }
    }
    
    func saveTodo(_ todo: TodoItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let index = self.todos.firstIndex(where: { $0.id == todo.id }) {
                self.todos[index] = todo
            } else {
                self.todos.insert(todo, at: 0)
            }
            
            self.presenter?.didSaveTodo(todo)
            self.saveTodosToUserDefaults()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.todos.removeAll { $0.id == todo.id }
            self.presenter?.didDeleteTodo(todo)
            self.saveTodosToUserDefaults()
        }
    }

    func searchTodos(with query: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if query.isEmpty {
                self.presenter?.didRetrieveTodos(self.todos)
            } else {
                let filteredTodos = self.todos.filter { todo in
                    todo.title.lowercased().contains(query.lowercased())
                }
                self.presenter?.didRetrieveTodos(filteredTodos)
            }
        }
    }
    
    func loadTodosFromAPI() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            if let path = Bundle.main.path(forResource: "todos", ofType: "json") {
                print("Found todos.json at path: \(path)")
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let todosArray = json?["todos"] as? [[String: Any]] {
                        self.todos.removeAll()
                        
                        for todoJson in todosArray {
                            if let todoItem = TodoItem(from: todoJson) {
                                self.todos.append(todoItem)
                            }
                        }
                        
                        UserDefaults.standard.set(true, forKey: "hasLoadedInitialData")
                        
                        DispatchQueue.main.async {
                            print("Successfully loaded \(todosArray.count) todos from JSON")
                            print("Total todos in memory: \(self.todos.count)")
                            self.presenter?.onSuccess("Successfully loaded \(todosArray.count) todos from JSON file")
                            self.presenter?.didRetrieveTodos(self.todos)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.presenter?.onError("Failed to load todos from JSON: \(error.localizedDescription)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.presenter?.onError("JSON file not found")
                }
            }
        }
    }
    
    // MARK: - UserDefaults Storage
    
    private func saveTodosToUserDefaults() {
        let todosData = todos.map { todo in
            [
                "id": todo.id,
                "title": todo.title,
                "description": todo.description,
                "createdAt": todo.createdAt.timeIntervalSince1970,
                "completed": todo.completed,
                "userId": todo.userId
            ] as [String: Any]
        }
        
        UserDefaults.standard.set(todosData, forKey: "savedTodos")
        print("Saved \(todos.count) todos to UserDefaults")
    }
    
    private func loadTodosFromUserDefaults() {
        guard let todosData = UserDefaults.standard.array(forKey: "savedTodos") as? [[String: Any]] else {
            print("No saved todos found in UserDefaults")
            return
        }
        
        todos = todosData.compactMap { data in
            guard let id = data["id"] as? Int32,
                  let title = data["title"] as? String,
                  let description = data["description"] as? String,
                  let createdAtInterval = data["createdAt"] as? TimeInterval,
                  let completed = data["completed"] as? Bool,
                  let userId = data["userId"] as? Int32 else {
                return nil
            }
            
            return TodoItem(
                id: id,
                title: title,
                description: description,
                createdAt: Date(timeIntervalSince1970: createdAtInterval),
                completed: completed,
                userId: userId
            )
        }
        
        print("Loaded \(todos.count) todos from UserDefaults")
    }
}

