//
//  TaskTableViewCell.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 1.12.24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = TaskTableViewCellConstants.colorViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: TaskTableViewCellConstants.titleLabelFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TaskTableViewCellConstants.descriptionLabelFontSize)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: TaskTableViewCellConstants.horizontalPadding),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: TaskTableViewCellConstants.colorViewWidth),
            colorView.heightAnchor.constraint(equalToConstant: TaskTableViewCellConstants.colorViewHeight),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: TaskTableViewCellConstants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -TaskTableViewCellConstants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: TaskTableViewCellConstants.titleLabelTopPadding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TaskTableViewCellConstants.descriptionLabelTopPadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: TaskTableViewCellConstants.descriptionLabelBottomPadding)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with model: TaskCellModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        colorView.backgroundColor = model.colorCode
    }
}
