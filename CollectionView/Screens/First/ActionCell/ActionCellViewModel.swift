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
	
	var preferredSize: CGSize { .zero }
	
	func makeView() -> ActionCellView {
		ActionCellView(self)
	}
}
