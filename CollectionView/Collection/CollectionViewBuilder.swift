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
		self.id = id
		self.layout = layout
		self.items = items()
		self.decorations = []
		self.header = nil
	}
	
	init(
		id: String,
		layout: CollectionLayout,
		@DecorationBuilder decorations: () -> [CollectionDecoration],
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.id = id
		self.layout = layout
		self.items = items()
		self.decorations = decorations()
		self.header = nil
	}
	
	init(
		id: String,
		layout: CollectionLayout,
		header: AnyCollectionItem,
		@DecorationBuilder decorations: () -> [CollectionDecoration],
		@ItemBuilder items: () -> [AnyCollectionItem]
	) {
		self.id = id
		self.layout = layout
		self.items = items()
		self.decorations = decorations()
		self.header = header
	}
}

// MARK: - Builder

@MainActor final class CollectionViewBuilder {
	
	private var sections: [CollectionSection] = []
	
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
	
	// MARK: - Build
	
	func build() -> CollectionViewContainer {
		CollectionViewContainer(sections: sections)
	}
	
	// MARK: - Result Builder API
	
	static func build(@SectionBuilder content: () -> [CollectionSection]) -> CollectionViewContainer {
		CollectionViewContainer(sections: content())
	}
}
