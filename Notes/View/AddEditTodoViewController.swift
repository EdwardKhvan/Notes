//
//  AddEditTodoViewController.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

class AddEditTodoViewController: UIViewController {
    
    var todo: TodoItem?
    var onSave: ((TodoItem) -> Void)?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название задачи"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание задачи"
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completedSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let completedLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        title = todo == nil ? "Новая задача" : "Редактировать задачу"
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(descriptionPlaceholderLabel)
        contentView.addSubview(completedSwitch)
        contentView.addSubview(completedLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 8),
            
            completedLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30),
            completedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            completedSwitch.centerYAnchor.constraint(equalTo: completedLabel.centerYAnchor),
            completedSwitch.leadingAnchor.constraint(equalTo: completedLabel.trailingAnchor, constant: 16),
            completedSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        descriptionTextView.delegate = self
    }
    
    func setupData() {
        if let todo = todo {
            titleTextField.text = todo.title
            descriptionTextView.text = todo.description
            completedSwitch.isOn = todo.completed
            updateDescriptionPlaceholder()
        } else {
            updateDescriptionPlaceholder()
        }
    }
    
    private func updateDescriptionPlaceholder() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "Ошибка", message: "Введите название задачи")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        let completed = completedSwitch.isOn
        
        let todoItem: TodoItem
        if let existingTodo = todo {
            todoItem = TodoItem(
                id: existingTodo.id,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                createdAt: existingTodo.createdAt,
                completed: completed,
                userId: existingTodo.userId
            )
        } else {
            todoItem = TodoItem(
                id: Int32.random(in: 1000...9999),
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                createdAt: Date(),
                completed: completed,
                userId: 1
            )
        }
        
        onSave?(todoItem)
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddEditTodoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
}
