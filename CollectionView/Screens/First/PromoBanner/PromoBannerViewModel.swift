//
//  PromoBannerViewModel.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

struct PromoBannerViewModel: Viewable, Identifiable, Sendable {
	
	let id: String
	let title: String
	let subtitle: String
	let backgroundColor: UIColor
	
	var preferredSize: CGSize { .zero }
	
	func makeView() -> PromoBannerView {
		PromoBannerView(self)
	}
}
