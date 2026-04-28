//
//  CollectionView.swift
//  CollectionView
//
//  Created by Дмитрий on 27.04.2026.
//

import UIKit

final class CollectionViewContainer: UICollectionView {
	
	// MARK: - Private
	
	private var sections: [CollectionSection]
	private var diffableDataSource: UICollectionViewDiffableDataSource<String, AnyCollectionItem>!
	private let delegateHandler = DelegateHandler()
	private var displayedIndexPaths = Set<IndexPath>()
	
	// MARK: - Init
	
	init(sections: [CollectionSection]) {
		self.sections = sections
		
		let placeholderLayout = UICollectionViewFlowLayout()
		super.init(frame: .zero, collectionViewLayout: placeholderLayout)
		
		let layout = makeLayout()
		Self.registerDecorations(from: sections, in: layout)
		setCollectionViewLayout(layout, animated: false)
		
		delegateHandler.container = self
		delegate = delegateHandler
		backgroundColor = .systemBackground
		
		configureDataSource()
		applySnapshot(animated: false)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Public Methods
	
	/// Обновляет элементы в конкретной секции
	func updateItems(in sectionId: String, items: [AnyCollectionItem], animated: Bool = true) {
		guard let index = sections.firstIndex(where: { $0.id == sectionId }) else { return }
		
		let section = sections[index]
		sections[index] = CollectionSection(
			id: section.id,
			layout: section.layout,
			items: items
		)
		applySnapshot(animated: animated)
	}
	
	/// Полностью перезагружает все секции
	func reloadAll(sections: [CollectionSection], animated: Bool = true) {
		self.sections = sections
		displayedIndexPaths.removeAll()
		
		let layout = makeLayout()
		Self.registerDecorations(from: sections, in: layout)
		setCollectionViewLayout(layout, animated: false)
		
		applySnapshot(animated: animated)
	}
	
	// MARK: - Private Methods
	
	fileprivate func notifyWillDisplayIfNeeded(at indexPath: IndexPath) {
		guard !displayedIndexPaths.contains(indexPath),
			  indexPath.section < sections.count,
			  indexPath.item < sections[indexPath.section].items.count
		else { return }
		
		displayedIndexPaths.insert(indexPath)
		sections[indexPath.section].items[indexPath.item].onWillDisplay?()
	}
	
	private func makeLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
			guard let self, sectionIndex < self.sections.count else { return nil }
			let section = self.sections[sectionIndex]
			let layoutSection = section.layout.makeLayoutSection(environment: environment)
			
			if !section.decorations.isEmpty {
				layoutSection.decorationItems = section.decorations.map { $0.makeDecorationItem() }
			}
			
			// visibleItemsInvalidationHandler покрывает ортогональный скролл,
			// где willDisplay делегата не вызывается
			layoutSection.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, environment in
				guard let self else { return }
				for visibleItem in visibleItems where visibleItem.representedElementCategory == .cell {
					self.notifyWillDisplayIfNeeded(at: visibleItem.indexPath)
				}
			}
			
			return layoutSection
		}
		
		// TODO: - Вынести отдельно
//		let configudation = UICollectionViewCompositionalLayoutConfiguration()
//		configudation.interSectionSpacing = 8
//		layout.configuration = configudation
		
		return layout
	}
	
	private static func registerDecorations(
		from sections: [CollectionSection],
		in layout: UICollectionViewCompositionalLayout
	) {
		var registered = Set<String>()
		for section in sections {
			for decoration in section.decorations where !registered.contains(decoration.elementKind) {
				layout.register(decoration.viewClass, forDecorationViewOfKind: decoration.elementKind)
				registered.insert(decoration.elementKind)
			}
		}
	}
	
	private func configureDataSource() {
		let cellRegistration = CellRegistration<UICollectionViewCell, AnyCollectionItem> {
			[weak self] cell, indexPath, item in
			cell.contentView.subviews.forEach { $0.removeFromSuperview() }
			
			let environment: ViewEnvironment
			if let self, indexPath.section < self.sections.count {
				environment = self.sections[indexPath.section].layout.viewEnvironment
			} else {
				environment = .undefined
			}
			
			let view = item.makeView(environment: environment)
			view.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(view)
			
			NSLayoutConstraint.activate([
				view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
				view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
				view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
				view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
			])
		}
		
		diffableDataSource = UICollectionViewDiffableDataSource<String, AnyCollectionItem>(
			collectionView: self
		) { collectionView, indexPath, item in
			collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: item
			)
		}
		
		configureSupplementaryViewProvider()
	}
	
	private func configureSupplementaryViewProvider() {
		let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>(
			elementKind: UICollectionView.elementKindSectionHeader
		) { [weak self] supplementaryView, elementKind, indexPath in
			guard let self, indexPath.section < self.sections.count,
				  let headerItem = self.sections[indexPath.section].header else { return }
			
			supplementaryView.subviews.forEach { $0.removeFromSuperview() }
			
			let environment = self.sections[indexPath.section].layout.viewEnvironment
			let view = headerItem.makeView(environment: environment)
			view.translatesAutoresizingMaskIntoConstraints = false
			supplementaryView.addSubview(view)
			
			NSLayoutConstraint.activate([
				view.topAnchor.constraint(equalTo: supplementaryView.topAnchor),
				view.leadingAnchor.constraint(equalTo: supplementaryView.leadingAnchor),
				view.trailingAnchor.constraint(equalTo: supplementaryView.trailingAnchor),
				view.bottomAnchor.constraint(equalTo: supplementaryView.bottomAnchor)
			])
		}
		
		diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
			collectionView.dequeueConfiguredReusableSupplementary(
				using: headerRegistration,
				for: indexPath
			)
		}
	}
	
	@MainActor private func applySnapshot(animated: Bool) {
		var snapshot = NSDiffableDataSourceSnapshot<String, AnyCollectionItem>()
		
		for section in sections {
			snapshot.appendSections([section.id])
			snapshot.appendItems(section.items, toSection: section.id)
		}
		
		diffableDataSource.apply(snapshot, animatingDifferences: animated)
	}
}

// MARK: - Delegate Handler

private extension CollectionViewContainer {
	
	final class DelegateHandler: NSObject, UICollectionViewDelegate {
		
		weak var container: CollectionViewContainer?
		
		func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
			collectionView.deselectItem(at: indexPath, animated: true)
			
			guard let container,
				  indexPath.section < container.sections.count,
				  indexPath.item < container.sections[indexPath.section].items.count
			else { return }
			
			container.sections[indexPath.section].items[indexPath.item].onSelect?()
		}
		
		func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
			// Дублирует visibleItemsInvalidationHandler для вертикального скролла,
			// notifyWillDisplayIfNeeded гарантирует одноразовый вызов через Set
			(collectionView as? CollectionViewContainer)?.notifyWillDisplayIfNeeded(at: indexPath)
		}
	}
}
