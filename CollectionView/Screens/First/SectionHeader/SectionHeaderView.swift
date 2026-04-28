//
//  SectionHeaderView.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

final class SectionHeaderView: UIView, ModelableView {
	
	typealias Model = SectionHeaderViewModel
	
	var model: SectionHeaderViewModel {
		didSet { updateUI() }
	}
	var updatable: Updatable?
	var viewEnvironment: ViewEnvironment
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	required init(_ model: SectionHeaderViewModel, environment: ViewEnvironment) {
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
		addSubview(titleLabel)
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.sectionInset),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.sectionInset),
			titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}
	
	private func updateUI() {
		titleLabel.text = model.title
	}
}
