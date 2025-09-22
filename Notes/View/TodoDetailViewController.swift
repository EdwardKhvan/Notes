//
//  TodoDetailViewController.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    var todo: TodoItem
    var onTodoUpdated: ((TodoItem) -> Void)?
    
    private var editingMode = false
    private var originalTodo: TodoItem?
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let statusContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 8
        textView.isHidden = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Редактировать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(todo: TodoItem) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        title = "Задача"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(statusContainerView)
        contentView.addSubview(descriptionContainerView)
        contentView.addSubview(editButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(dateLabel)
        
        statusContainerView.addSubview(statusImageView)
        statusContainerView.addSubview(statusLabel)
        
        descriptionContainerView.addSubview(descriptionLabel)
        descriptionContainerView.addSubview(descriptionTextView)
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            statusContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            statusContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            statusImageView.centerYAnchor.constraint(equalTo: statusContainerView.centerYAnchor),
            statusImageView.leadingAnchor.constraint(equalTo: statusContainerView.leadingAnchor, constant: 16),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.centerYAnchor.constraint(equalTo: statusContainerView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusContainerView.trailingAnchor, constant: -16),
            
            descriptionContainerView.topAnchor.constraint(equalTo: statusContainerView.bottomAnchor, constant: 16),
            descriptionContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -8),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -8),
            
            editButton.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        let statusTapGesture = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        statusContainerView.addGestureRecognizer(statusTapGesture)
        
        let descriptionTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionTapped))
        descriptionContainerView.addGestureRecognizer(descriptionTapGesture)
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    private func setupData() {
        titleLabel.text = todo.title
        titleTextField.text = todo.title
        descriptionLabel.text = todo.description.isEmpty ? "Без описания" : todo.description
        descriptionTextView.text = todo.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        dateLabel.text = "Создано: \(formatter.string(from: todo.createdAt))"
        
        if todo.completed {
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .systemGreen
            statusLabel.text = "Выполнено"
            statusLabel.textColor = .systemGreen
            titleLabel.attributedText = NSAttributedString(
                string: todo.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.textColor = .systemGray
        } else {
            statusImageView.image = UIImage(systemName: "circle")
            statusImageView.tintColor = .systemGray3
            statusLabel.text = "Не выполнено"
            statusLabel.textColor = .systemGray
            titleLabel.text = todo.title
            titleLabel.textColor = .label
            titleLabel.attributedText = NSAttributedString(string: todo.title, attributes: [.strikethroughStyle: nil ?? NSUnderlineStyle.byWord])
        }
    }
    
    @objc private func editButtonTapped() {
        startEditing()
    }
    
    @objc private func saveButtonTapped() {
        saveChanges()
    }
    
    @objc private func cancelButtonTapped() {
        cancelEditing()
    }
    
    @objc private func statusTapped() {
        if !editingMode {
            // Переключаем статус выполнения только если не в режиме редактирования
            todo.completed.toggle()
            setupData()
            onTodoUpdated?(todo)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.statusContainerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.statusContainerView.transform = .identity
                }
            }
        }
    }
    
    @objc private func descriptionTapped() {
        if !editingMode {
            startEditing()
        }
    }
    
    private func startEditing() {
        editingMode = true
        originalTodo = todo
        
        titleLabel.isHidden = true
        titleTextField.isHidden = false
        descriptionLabel.isHidden = true
        descriptionTextView.isHidden = false
        
        editButton.isHidden = true
        saveButton.isHidden = false
        cancelButton.isHidden = false
        
        statusContainerView.isUserInteractionEnabled = false
        descriptionContainerView.isUserInteractionEnabled = false
        
        titleTextField.becomeFirstResponder()
    }
    
    private func saveChanges() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "Ошибка", message: "Введите название задачи")
            return
        }
        
        let description = descriptionTextView.text ?? ""
        
        todo = TodoItem(
            id: todo.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: todo.createdAt,
            completed: todo.completed,
            userId: todo.userId
        )
        
        finishEditing()
        onTodoUpdated?(todo)
    }
    
    private func cancelEditing() {
        if let original = originalTodo {
            todo = original
        }
        finishEditing()
    }
    
    private func finishEditing() {
        editingMode = false
        originalTodo = nil
        
        titleLabel.isHidden = false
        titleTextField.isHidden = true
        descriptionLabel.isHidden = false
        descriptionTextView.isHidden = true
        
        editButton.isHidden = false
        saveButton.isHidden = true
        cancelButton.isHidden = true
        
        statusContainerView.isUserInteractionEnabled = true
        descriptionContainerView.isUserInteractionEnabled = true
        
        view.endEditing(true)
        
        setupData()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TodoDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
}

extension TodoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height > 80 {
            descriptionContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: size.height + 16).isActive = true
        }
    }
}
