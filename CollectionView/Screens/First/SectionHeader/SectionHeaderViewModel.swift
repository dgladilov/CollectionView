//
//  SectionHeaderViewModel.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

struct SectionHeaderViewModel: Viewable, Identifiable, Sendable {
	
	let id: String
	let title: String
	
	var preferredSize: CGSize {
		CGSize(width: 0, height: 44)
	}
	
	func makeView() -> SectionHeaderView {
		SectionHeaderView(self)
	}
}
