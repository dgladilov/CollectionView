//
//  PromoCardViewModel.swift
//  CollectionView
//
//  Created by Дмитрий on 29.04.2026.
//

import UIKit

struct PromoCardViewModel: Viewable, Identifiable, Sendable {

	enum Size: Sendable {
		/// Высокая карточка — занимает всю высоту группы (левая колонка)
		case tall
		/// Обычная карточка — половина высоты группы (правая колонка)
		case regular
	}

	let id: String
	let title: String
	let subtitle: String?
	let backgroundColor: UIColor
	let size: Size

	var preferredSize: CGSize { .zero }

	func makeView() -> PromoCardView {
		PromoCardView(self)
	}
}
