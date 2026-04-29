//
//  PromoBannerView.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

final class PromoBannerView: UIView, ModelableView {
	
	typealias Model = PromoBannerViewModel
	
	var model: PromoBannerViewModel {
		didSet { updateUI() }
	}
	var updatable: Updatable?
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .bold)
		label.textColor = .white
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = .white.withAlphaComponent(0.8)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let actionButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Подробнее", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
		button.backgroundColor = UIColor.white.withAlphaComponent(0.25)
		button.layer.cornerRadius = 14
		button.translatesAutoresizingMaskIntoConstraints = false
		button.isUserInteractionEnabled = false
		return button
	}()
	
	required init(_ model: PromoBannerViewModel) {
		self.model = model
		super.init(frame: .zero)
		setupUI()
		updateUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		layer.cornerRadius = LayoutConstants.sectionCornerRadius
		layer.masksToBounds = true
		
		addSubview(titleLabel)
		addSubview(subtitleLabel)
		addSubview(actionButton)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
			subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			
			actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
			actionButton.heightAnchor.constraint(equalToConstant: 28),
			actionButton.widthAnchor.constraint(equalToConstant: 100),
		])
	}
	
	private func updateUI() {
		titleLabel.text = model.title
		subtitleLabel.text = model.subtitle
		backgroundColor = model.backgroundColor
	}
}
