//
//  ActionCellViewModel.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

struct ActionCellViewModel: Viewable, Identifiable, Sendable {
	
	let id: String
	let title: String
	let subtitle: String?
	let iconName: String
	let iconBackgroundColor: UIColor
	
	var preferredSize: CGSize {
		CGSize(width: 0, height: 56)
	}
	
	func makeView() -> ActionCellView {
		ActionCellView(self, environment: .plain)
	}
	
	func makeView(environment: ViewEnvironment) -> ActionCellView {
		ActionCellView(self, environment: environment)
	}
}
