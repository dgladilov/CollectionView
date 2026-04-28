//
//  FirstViewController.swift
//  CollectionView
//
//  Created by Дмитрий on 24.04.2026.
//

import UIKit

final class FirstViewController: UIViewController {
	
	private var collectionContainer: CollectionViewContainer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGroupedBackground
		title = "Купер"
		
		setupCollection()
	}
	
	// MARK: - Private
	
	private static let moduleDecorationKind = "module-background"
	
	private static func moduleDecoration() -> CollectionDecoration {
		CollectionDecoration(
			elementKind: moduleDecorationKind,
			viewClass: SectionBackgroundView.self
		)
	}
	
	private func setupCollection() {
		let inset = LayoutConstants.sectionInset
		
		collectionContainer = CollectionViewBuilder.build {
			// Модуль 1: "Выгодные предложения" + промо-баннеры
			CollectionSection(
				id: "promo_module",
				layout: .custom(.module) { environment in
					let bannerSize = NSCollectionLayoutSize(
						widthDimension: .absolute(260),
						heightDimension: .absolute(160)
					)
					let bannerItem = NSCollectionLayoutItem(layoutSize: bannerSize)
					let bannerGroup = NSCollectionLayoutGroup.horizontal(
						layoutSize: bannerSize,
						subitems: [bannerItem]
					)
					
					let section = NSCollectionLayoutSection(group: bannerGroup)
					section.orthogonalScrollingBehavior = .continuous
					section.interGroupSpacing = LayoutConstants.interItemSpacing
					section.contentInsets = NSDirectionalEdgeInsets(
						top: 0,
						leading: inset,
						bottom: inset,
						trailing: inset
					)
					
					let headerBoundary = NSCollectionLayoutBoundarySupplementaryItem(
						layoutSize: NSCollectionLayoutSize(
							widthDimension: .fractionalWidth(1.0),
							heightDimension: .absolute(44)
						),
						elementKind: UICollectionView.elementKindSectionHeader,
						alignment: .top
					)
					section.boundarySupplementaryItems = [headerBoundary]
					
					return section
				},
				header: CollectionItem(
					id: "header_promo",
					model: SectionHeaderViewModel(id: "header_promo", title: "Выгодные предложения")
				).erased(),
				decorations: {
					Self.moduleDecoration()
				}
			) {
				CollectionItem(
					id: "promo_1",
					model: PromoBannerViewModel(
						id: "promo_1",
						title: "Пополните яблоко\nв Купере",
						subtitle: "Быстро и удобно",
						backgroundColor: .systemGreen
					)
				).erased()
				CollectionItem(
					id: "promo_2",
					model: PromoBannerViewModel(
						id: "promo_2",
						title: "Скидка до 50%\nна первый заказ",
						subtitle: "Только сегодня",
						backgroundColor: .systemBlue
					)
				).erased()
				CollectionItem(
					id: "promo_3",
					model: PromoBannerViewModel(
						id: "promo_3",
						title: "Бесплатная\nдоставка",
						subtitle: "При заказе от 1000₽",
						backgroundColor: .systemPurple
					)
				).erased()
			}
			
			// Модуль 2: Action-ячейки
			CollectionSection(
				id: "actions_module",
				layout: .custom(.module) { environment in
					let itemSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .absolute(56)
					)
					let item = NSCollectionLayoutItem(layoutSize: itemSize)
					let groupSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .absolute(56)
					)
					let group = NSCollectionLayoutGroup.vertical(
						layoutSize: groupSize,
						subitems: [item]
					)
					let section = NSCollectionLayoutSection(group: group)
					section.contentInsets = NSDirectionalEdgeInsets(
						top: inset,
						leading: inset,
						bottom: inset,
						trailing: inset
					)
					return section
				},
				decorations: {
					Self.moduleDecoration()
				}
			) {
				CollectionItem(
					id: "action_go_kuper",
					model: ActionCellViewModel(
						id: "action_go_kuper",
						title: "Перейти в Купер",
						subtitle: nil,
						iconName: "cart.fill",
						iconBackgroundColor: .systemGreen
					)
				).erased()
				CollectionItem(
					id: "action_cashback",
					model: ActionCellViewModel(
						id: "action_cashback",
						title: "Кешбэк 20%",
						subtitle: "на пополнение кошелька",
						iconName: "percent",
						iconBackgroundColor: .systemOrange
					)
				).erased()
			}
			
			// Модуль 3: "Доставка продуктов" + товарные баннеры
			CollectionSection(
				id: "delivery_module",
				layout: .custom(.module) { environment in
					let bannerSize = NSCollectionLayoutSize(
						widthDimension: .absolute(260),
						heightDimension: .absolute(160)
					)
					let bannerItem = NSCollectionLayoutItem(layoutSize: bannerSize)
					let bannerGroup = NSCollectionLayoutGroup.horizontal(
						layoutSize: bannerSize,
						subitems: [bannerItem]
					)
					
					let section = NSCollectionLayoutSection(group: bannerGroup)
					section.orthogonalScrollingBehavior = .continuous
					section.interGroupSpacing = LayoutConstants.interItemSpacing
					section.contentInsets = NSDirectionalEdgeInsets(
						top: 0,
						leading: inset,
						bottom: inset,
						trailing: inset
					)
					
					let headerBoundary = NSCollectionLayoutBoundarySupplementaryItem(
						layoutSize: NSCollectionLayoutSize(
							widthDimension: .fractionalWidth(1.0),
							heightDimension: .absolute(44)
						),
						elementKind: UICollectionView.elementKindSectionHeader,
						alignment: .top
					)
					section.boundarySupplementaryItems = [headerBoundary]
					
					return section
				},
				header: CollectionItem(
					id: "header_delivery",
					model: SectionHeaderViewModel(id: "header_delivery", title: "Доставка продуктов")
				).erased(),
				decorations: {
					Self.moduleDecoration()
				}
			) {
				CollectionItem(
					id: "delivery_1",
					model: PromoBannerViewModel(
						id: "delivery_1",
						title: "Свежие фрукты",
						subtitle: "Доставка за 30 минут",
						backgroundColor: .systemTeal
					)
				).erased()
				CollectionItem(
					id: "delivery_2",
					model: PromoBannerViewModel(
						id: "delivery_2",
						title: "Молочные продукты",
						subtitle: "Фермерские",
						backgroundColor: .systemIndigo
					)
				).erased()
				CollectionItem(
					id: "delivery_3",
					model: PromoBannerViewModel(
						id: "delivery_3",
						title: "Мясо и рыба",
						subtitle: "Охлаждённые",
						backgroundColor: .systemRed
					)
				).erased()
			}
		}
		
		collectionContainer.backgroundColor = .systemGroupedBackground
		collectionContainer.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionContainer)
		NSLayoutConstraint.activate([
			collectionContainer.topAnchor.constraint(equalTo: view.topAnchor),
			collectionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			collectionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			collectionContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
}
