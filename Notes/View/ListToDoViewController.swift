//
//  ListToDoViewController.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

class ListTodoViewController: UIViewController {
    var presenter: ListTodoPresenterProtocol?
    var todos: [TodoItem] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = nil
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Загрузить из JSON", style: .plain, target: self, action: #selector(loadFromAPI))
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(tasksCountLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tasksCountLabel.topAnchor),
            
            tasksCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksCountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tasksCountLabel.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func addTodo() {
        let addEditVC = AddEditTodoViewController()
        addEditVC.onSave = { [weak self] todo in
            self?.presenter?.addTodo(todo)
        }
        
        let navController = UINavigationController(rootViewController: addEditVC)
        present(navController, animated: true)
    }
    
    @objc private func loadFromAPI() {
        presenter?.loadTodosFromAPI()
    }
    
    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let todo = todos[indexPath.row]
                showActionMenu(for: todo, at: indexPath)
            }
        }
    }
    
    private func showActionMenu(for todo: TodoItem, at indexPath: IndexPath) {
        let alert = UIAlertController(title: todo.title, message: "Выберите действие", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Редактировать", style: .default) { [weak self] _ in
            self?.editTodo(todo)
        })
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.deleteTodo(todo)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            let cell = tableView.cellForRow(at: indexPath)
            popover.sourceView = cell
            popover.sourceRect = cell?.bounds ?? CGRect.zero
        }
        
        present(alert, animated: true)
    }
    
    private func editTodo(_ todo: TodoItem) {
        let addEditVC = AddEditTodoViewController()
        addEditVC.todo = todo
        addEditVC.onSave = { [weak self] updatedTodo in
            self?.presenter?.editTodo(updatedTodo)
        }
        
        let navController = UINavigationController(rootViewController: addEditVC)
        present(navController, animated: true)
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func deleteTodo(_ todo: TodoItem) {
        let alert = UIAlertController(title: "Удалить задачу", message: "Вы уверены, что хотите удалить эту задачу?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.presenter?.deleteTodo(todo)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func updateTasksCount() {
        let completedCount = todos.filter { $0.completed }.count
        let totalCount = todos.count
        tasksCountLabel.text = "Всего задач: \(totalCount) | Выполнено: \(completedCount)"
    }
    
    private func toggleTodoStatus(at indexPath: IndexPath) {
        var todo = todos[indexPath.row]
        todo.completed.toggle()
        presenter?.editTodo(todo)
    }
}

extension ListTodoViewController: ListTodoViewProtocol {
    func showTodos(_ todos: [TodoItem]) {
        print("ViewController: Received \(todos.count) todos to display")
        self.todos = todos
        tableView.reloadData()
        updateTasksCount()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

extension ListTodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.onStatusToggle = { [weak self] in
            self?.toggleTodoStatus(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editTodo(todos[indexPath.row])
//        let todo = todos[indexPath.row]
//        
//        let detailVC = TodoDetailViewController(todo: todo)
//        detailVC.onTodoUpdated = { [weak self] updatedTodo in
//            self?.presenter?.editTodo(updatedTodo)
//        }
//        
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            deleteTodo(todo)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ListTodoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTodos(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter?.searchTodos(with: "")
    }
}
