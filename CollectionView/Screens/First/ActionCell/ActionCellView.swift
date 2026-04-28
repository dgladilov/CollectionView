//
//  ActionCellView.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

final class ActionCellView: UIView, ModelableView {
	
	typealias Model = ActionCellViewModel
	
	var model: ActionCellViewModel {
		didSet { updateUI() }
	}
	var updatable: Updatable?
	var viewEnvironment: ViewEnvironment
	
	private let iconContainer: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 12
		view.layer.masksToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .medium)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .regular)
		label.textColor = .secondaryLabel
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let textStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 2
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let chevron: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
		let imageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: config))
		imageView.tintColor = .tertiaryLabel
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.setContentHuggingPriority(.required, for: .horizontal)
		return imageView
	}()
	
	required init(_ model: ActionCellViewModel, environment: ViewEnvironment) {
		self.model = model
		self.viewEnvironment = environment
		super.init(frame: .zero)
		setupUI()
		updateUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		addSubview(iconContainer)
		iconContainer.addSubview(iconImageView)
		
		textStack.addArrangedSubview(titleLabel)
		textStack.addArrangedSubview(subtitleLabel)
		addSubview(textStack)
		addSubview(chevron)
		
		NSLayoutConstraint.activate([
			iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
			iconContainer.widthAnchor.constraint(equalToConstant: 36),
			iconContainer.heightAnchor.constraint(equalToConstant: 36),
			
			iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
			iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 20),
			iconImageView.heightAnchor.constraint(equalToConstant: 20),
			
			textStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
			textStack.centerYAnchor.constraint(equalTo: centerYAnchor),
			textStack.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
			
			chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	private func updateUI() {
		titleLabel.text = model.title
		subtitleLabel.text = model.subtitle
		subtitleLabel.isHidden = model.subtitle == nil
		iconContainer.backgroundColor = model.iconBackgroundColor
		iconImageView.image = UIImage(systemName: model.iconName)
	}
}
