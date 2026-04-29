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
	private var layoutConfiguration: UICollectionViewCompositionalLayoutConfiguration
	private lazy var diffableDataSource: UICollectionViewDiffableDataSource<String, AnyCollectionItem> = makeDataSource()
	private let delegateHandler = DelegateHandler()
	private var displayedIndexPaths = Set<IndexPath>()
	
	// MARK: - Init
	
	init(
		sections: [CollectionSection],
		configuration: UICollectionViewCompositionalLayoutConfiguration = .default
	) {
		self.sections = sections
		self.layoutConfiguration = configuration
		
		super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		
		let layout = makeLayout()
		Self.registerDecorations(from: sections, in: layout)
		setCollectionViewLayout(layout, animated: false)
		
		delegateHandler.container = self
		delegate = delegateHandler
		backgroundColor = .systemBackground
		
		// Обращение к lazy var инициализирует data source с реальным self
		configureSupplementaryViewProvider()
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
			items: items,
			decorations: section.decorations,
			header: section.header,
			footer: section.footer
		)
		applySnapshot(animated: animated)
	}
	
	/// Добавляет секцию в конец
	func appendSection(_ section: CollectionSection, animated: Bool = true) {
		sections.append(section)
		rebuildLayout()
		applySnapshot(animated: animated)
	}
	
	/// Вставляет секцию перед указанной
	func insertSection(_ section: CollectionSection, before targetId: String, animated: Bool = true) {
		let index = sections.firstIndex(where: { $0.id == targetId }) ?? 0
		sections.insert(section, at: index)
		rebuildLayout()
		applySnapshot(animated: animated)
	}
	
	/// Вставляет секцию после указанной
	func insertSection(_ section: CollectionSection, after targetId: String, animated: Bool = true) {
		let index = sections.firstIndex(where: { $0.id == targetId }).map { $0 + 1 } ?? sections.count
		sections.insert(section, at: index)
		rebuildLayout()
		applySnapshot(animated: animated)
	}
	
	/// Удаляет секцию по идентификатору
	func removeSection(id: String, animated: Bool = true) {
		sections.removeAll { $0.id == id }
		rebuildLayout()
		applySnapshot(animated: animated)
	}
	
	/// Полностью перезагружает все секции
	func reloadAll(
		sections: [CollectionSection],
		configuration: UICollectionViewCompositionalLayoutConfiguration? = nil,
		animated: Bool = true
	) {
		self.sections = sections
		if let configuration { self.layoutConfiguration = configuration }
		displayedIndexPaths.removeAll()
		
		let layout = makeLayout()
		Self.registerDecorations(from: sections, in: layout)
		setCollectionViewLayout(layout, animated: false)
		
		applySnapshot(animated: animated)
	}
	
	// MARK: - Private Methods

	/// Пересоздаёт layout и регистрирует декорации после структурного изменения секций
	private func rebuildLayout() {
		let layout = makeLayout()
		Self.registerDecorations(from: sections, in: layout)
		setCollectionViewLayout(layout, animated: false)
	}
	
	fileprivate func notifyWillDisplayIfNeeded(at indexPath: IndexPath) {
		guard !displayedIndexPaths.contains(indexPath),
			  indexPath.section < sections.count,
			  indexPath.item < sections[indexPath.section].items.count
		else { return }
		
		displayedIndexPaths.insert(indexPath)
		sections[indexPath.section].items[indexPath.item].onWillDisplay?()
	}
	
	private func makeLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout(
			sectionProvider: { [weak self] sectionIndex, environment in
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
			},
			configuration: layoutConfiguration
		)
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
	
	private func makeDataSource() -> UICollectionViewDiffableDataSource<String, AnyCollectionItem> {
		let cellRegistration = CellRegistration<UICollectionViewCell, AnyCollectionItem> {
			cell, indexPath, item in
			cell.contentView.subviews.forEach { $0.removeFromSuperview() }
			
			let view = item.makeView()
			view.translatesAutoresizingMaskIntoConstraints = false
			cell.contentView.addSubview(view)
			
			NSLayoutConstraint.activate([
				view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
				view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
				view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
				view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
			])
		}
		
		return UICollectionViewDiffableDataSource<String, AnyCollectionItem>(
			collectionView: self
		) { collectionView, indexPath, item in
			collectionView.dequeueConfiguredReusableCell(
				using: cellRegistration,
				for: indexPath,
				item: item
			)
		}
	}
	
	private func configureSupplementaryViewProvider() {
		let headerRegistration = makeSupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) {
			self.sections[safe: $0.section]?.header
		}
		let footerRegistration = makeSupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) {
			self.sections[safe: $0.section]?.footer
		}
		
		diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
			switch elementKind {
			case UICollectionView.elementKindSectionHeader:
				return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
			case UICollectionView.elementKindSectionFooter:
				return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
			default:
				return nil
			}
		}
	}
	
	private func makeSupplementaryRegistration(
		elementKind: String,
		itemProvider: @escaping (IndexPath) -> AnyCollectionItem?
	) -> UICollectionView.SupplementaryRegistration<UICollectionReusableView> {
		UICollectionView.SupplementaryRegistration<UICollectionReusableView>(
			elementKind: elementKind
		) { supplementaryView, _, indexPath in
			guard let item = itemProvider(indexPath) else { return }
			supplementaryView.subviews.forEach { $0.removeFromSuperview() }
			let view = item.makeView()
			view.translatesAutoresizingMaskIntoConstraints = false
			supplementaryView.addSubview(view)
			NSLayoutConstraint.activate([
				view.topAnchor.constraint(equalTo: supplementaryView.topAnchor),
				view.leadingAnchor.constraint(equalTo: supplementaryView.leadingAnchor),
				view.trailingAnchor.constraint(equalTo: supplementaryView.trailingAnchor),
				view.bottomAnchor.constraint(equalTo: supplementaryView.bottomAnchor)
			])
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

// MARK: - Array Safe Subscript

private extension Array {
	subscript(safe index: Int) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

// MARK: - UICollectionViewCompositionalLayoutConfiguration

extension UICollectionViewCompositionalLayoutConfiguration {
	
	static var `default`: UICollectionViewCompositionalLayoutConfiguration {
		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.interSectionSpacing = LayoutConstants.interGroupSpacing
		return configuration
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
