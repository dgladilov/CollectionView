//
//  SectionBackgroundView.swift
//  CollectionView
//
//  Created by Дмитрий on 28.04.2026.
//

import UIKit

final class SectionBackgroundView: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .secondarySystemGroupedBackground
		layer.cornerRadius = LayoutConstants.sectionCornerRadius
		clipsToBounds = true
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
