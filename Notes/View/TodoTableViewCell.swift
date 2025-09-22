//
//  TodoTableViewCell.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    static let identifier = "TodoTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    var onStatusToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusImageView)
        
        NSLayoutConstraint.activate([
            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusImageTapped))
        statusImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func statusImageTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.onStatusToggle?()
        }
    }
    
    func configure(with todo: TodoItem) {
        titleLabel.attributedText = nil
        titleLabel.text = nil
        
        descriptionLabel.text = todo.description.isEmpty ? "Без описания" : todo.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: todo.createdAt)
        
        if todo.completed {
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .systemYellow
            titleLabel.attributedText = NSAttributedString(
                string: todo.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.textColor = .systemGray
        } else {
            statusImageView.image = UIImage(systemName: "circle")
            statusImageView.tintColor = .systemGray3
            titleLabel.text = todo.title
            titleLabel.textColor = .label
        }
    }
}
