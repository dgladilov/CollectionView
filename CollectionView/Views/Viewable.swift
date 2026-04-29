//
//  Viewable.swift
//  CollectionView
//
//  Created by Дмитрий on 24.04.2026.
//

import UIKit

// MARK: - Uneditable

protocol Viewable {

	associatedtype ViewType: UIView

	@MainActor var preferredSize: CGSize { get }

	@MainActor func makeView() -> ViewType
}

extension Viewable {
	
	@MainActor var preferredSize: CGSize { .init(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric) }
}

protocol Updatable {

	func update(animated: Bool)
}

protocol ModelableView: UIView {

	associatedtype Model

	var model: Model { get set }

	var updatable: Updatable? { get set }

	init(_ model: Model)
}

// MARK: - Editable

protocol CollectionItemable {

	associatedtype ViewType: Viewable & Identifiable

	func makeItem() -> CollectionItem<ViewType>
}

struct CollectionItem<ModelType: Viewable & Identifiable & Sendable>: Hashable, Sendable {

	let id: String

	let model: ModelType

	func hash(into hasher: inout Hasher) {
		hasher.combine(model.id)
	}

	static func == (lhs: CollectionItem<ModelType>, rhs: CollectionItem<ModelType>) -> Bool {
		lhs.id == rhs.id
	}

	@MainActor func erased() -> AnyCollectionItem {
		AnyCollectionItem(
			id: id,
			preferredSize: model.preferredSize,
			view: model
		)
	}
}

// MARK: - Type-Erased Collection Item

struct AnyCollectionItem: Hashable, Sendable {

	let id: String
	let preferredSize: CGSize
	private let view: any Viewable & Sendable
	let onSelect: (@Sendable () -> Void)?
	let onWillDisplay: (@Sendable () -> Void)?

	init(
		id: String,
		preferredSize: CGSize,
		view: any Viewable & Sendable,
		onSelect: (@Sendable () -> Void)? = nil,
		onWillDisplay: (@Sendable () -> Void)? = nil
	) {
		self.id = id
		self.preferredSize = preferredSize
		self.view = view
		self.onSelect = onSelect
		self.onWillDisplay = onWillDisplay
	}

	@MainActor func makeView() -> UIView {
		view.makeView()
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func == (lhs: AnyCollectionItem, rhs: AnyCollectionItem) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - Collection Layout

enum CollectionLayout {
	/// Плоский список (UICollectionLayoutListConfiguration.Appearance.plain)
	case plain
	/// Сгруппированный список с отступами (insetGrouped)
	case insetGrouped
	/// Сгруппированный список (grouped)
	case grouped
	/// Боковая панель (sidebar)
	case sidebar
	/// Боковая панель плоская (sidebarPlain)
	case sidebarPlain
	/// Кастомный лейаут
	case custom((NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection)

	@MainActor func makeLayoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		switch self {
		case .plain:
			let config = UICollectionLayoutListConfiguration(appearance: .plain)
			return .list(using: config, layoutEnvironment: environment)
		case .insetGrouped:
			let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
			return .list(using: config, layoutEnvironment: environment)
		case .grouped:
			let config = UICollectionLayoutListConfiguration(appearance: .grouped)
			return .list(using: config, layoutEnvironment: environment)
		case .sidebar:
			let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
			return .list(using: config, layoutEnvironment: environment)
		case .sidebarPlain:
			let config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
			return .list(using: config, layoutEnvironment: environment)
		case .custom(let provider):
			return provider(environment)
		}
	}
}

// MARK: - Collection Decoration

struct CollectionDecoration {

	let elementKind: String
	let viewClass: UICollectionReusableView.Type
	let contentInsets: NSDirectionalEdgeInsets

	init(
		elementKind: String,
		viewClass: UICollectionReusableView.Type,
		contentInsets: NSDirectionalEdgeInsets = .zero
	) {
		self.elementKind = elementKind
		self.viewClass = viewClass
		self.contentInsets = contentInsets
	}

	@MainActor func makeDecorationItem() -> NSCollectionLayoutDecorationItem {
		let item = NSCollectionLayoutDecorationItem.background(elementKind: elementKind)
		item.contentInsets = contentInsets
		return item
	}
}

// MARK: - Collection Section

struct CollectionSection {

	let id: String
	let layout: CollectionLayout
	let items: [AnyCollectionItem]
	let decorations: [CollectionDecoration]
	let header: AnyCollectionItem?
	let footer: AnyCollectionItem?

	init(
		id: String,
		layout: CollectionLayout,
		items: [AnyCollectionItem],
		decorations: [CollectionDecoration] = [],
		header: AnyCollectionItem? = nil,
		footer: AnyCollectionItem? = nil
	) {
		self.id = id
		self.layout = layout
		self.items = items
		self.decorations = decorations
		self.header = header
		self.footer = footer
	}
}
