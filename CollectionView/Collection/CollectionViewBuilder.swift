//
//  CollectionViewBuilder.swift
//  CollectionView
//
//  Created by Дмитрий on 27.04.2026.
//

import UIKit

// MARK: - Result Builder

@resultBuilder
enum SectionBuilder {
	
	static func buildBlock(_ components: CollectionSection...) -> [CollectionSection] {
		components
	}
	
	static func buildBlock(_ components: [CollectionSection]...) -> [CollectionSection] {
		components.flatMap { $0 }
	}
	
	static func buildOptional(_ component: [CollectionSection]?) -> [CollectionSection] {
		component ?? []
	}
	
	static func buildEither(first component: [CollectionSection]) -> [CollectionSection] {
		component
	}
	
	static func buildEither(second component: [CollectionSection]) -> [CollectionSection] {
		component
	}
	
	static func buildArray(_ components: [[CollectionSection]]) -> [CollectionSection] {
		components.flatMap { $0 }
	}
}

@resultBuilder
enum ItemBuilder {
	
	static func buildBlock(_ components: AnyCollectionItem...) -> [AnyCollectionItem] {
		components
	}
	
	static func buildBlock(_ components: [AnyCollectionItem]...) -> [AnyCollectionItem] {
		components.flatMap { $0 }
	}
	
	static func buildOptional(_ component: [AnyCollectionItem]?) -> [AnyCollectionItem] {
		component ?? []
	}
	
	static func buildEither(first component: [AnyCollectionItem]) -> [AnyCollectionItem] {
		component
	}
	
	static func buildEither(second component: [AnyCollectionItem]) -> [AnyCollectionItem] {
		component
	}
	
	static func buildArray(_ components: [[AnyCollectionItem]]) -> [AnyCollectionItem] {
		components.flatMap { $0 }
	}
}

@resultBuilder
enum DecorationBuilder {
	
	static func buildBlock(_ components: CollectionDecoration...) -> [CollectionDecoration] {
		components
	}
	
	static func buildBlock(_ components: [CollectionDecoration]...) -> [CollectionDecoration] {
		components.flatMap { $0 }
	}
	
	static func buildOptional(_ component: [CollectionDecoration]?) -> [CollectionDecoration] {
		component ?? []
	}
	
	static func buildEither(first component: [CollectionDecoration]) -> [CollectionDecoration] {
		component
	}
	
	static func buildEither(second component: [CollectionDecoration]) -> [CollectionDecoration] {
		component
	}
	
	static func buildArray(_ components: [[CollectionDecoration]]) -> [CollectionDecoration] {
		components.flatMap { $0 }
	}
}

// MARK: - CollectionSection convenience inits

extension CollectionSection {
	
	init(
		id: String,
		layout: CollectionLayout,
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.init(id: id, layout: layout, items: items())
	}
	
	init(
		id: String,
		layout: CollectionLayout,
		@DecorationBuilder decorations: () -> [CollectionDecoration],
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.init(id: id, layout: layout, items: items(), decorations: decorations())
	}
	
	init(
		id: String,
		layout: CollectionLayout,
		header: AnyCollectionItem? = nil,
		footer: AnyCollectionItem? = nil,
		@DecorationBuilder decorations: () -> [CollectionDecoration],
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.init(
			id: id,
			layout: layout,
			items: items(),
			decorations: decorations(),
			header: header,
			footer: footer
		)
	}
	
	init(
		id: String,
		layout: CollectionLayout,
		header: AnyCollectionItem? = nil,
		footer: AnyCollectionItem? = nil,
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.init(
			id: id,
			layout: layout,
			items: items(),
			header: header,
			footer: footer
		)
	}
}

// MARK: - Builder

@MainActor final class CollectionViewBuilder {
	
	private var sections: [CollectionSection] = []
	private var configuration: UICollectionViewCompositionalLayoutConfiguration = .default
	
	// MARK: - Chaining API
	
	@discardableResult
	func addSection(
		id: String,
		layout: CollectionLayout,
		items: [AnyCollectionItem]
	) -> CollectionViewBuilder {
		let section = CollectionSection(
			id: id,
			layout: layout,
			items: items
		)
		sections.append(section)
		return self
	}
	
	@discardableResult
	func configuration(_ configuration: UICollectionViewCompositionalLayoutConfiguration) -> CollectionViewBuilder {
		self.configuration = configuration
		return self
	}
	
	// MARK: - Build
	
	func build() -> CollectionViewContainer {
		CollectionViewContainer(sections: sections, configuration: configuration)
	}
	
	// MARK: - Result Builder API
	
	static func make(
		configuration: UICollectionViewCompositionalLayoutConfiguration = .default,
		@SectionBuilder content: () -> [CollectionSection]
	) -> CollectionViewContainer {
		CollectionViewContainer(sections: content(), configuration: configuration)
	}
}
