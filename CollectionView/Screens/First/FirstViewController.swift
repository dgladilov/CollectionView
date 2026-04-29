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
		
		collectionContainer = CollectionViewBuilder.make {
			// Модуль 1: "Выгодные предложения" + промо-баннеры
			CollectionSection(
				id: "promo_module",
				layout: .custom { environment in
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
				layout: .custom { environment in
					let itemSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .estimated(56)
					)
					let item = NSCollectionLayoutItem(layoutSize: itemSize)
					let group = NSCollectionLayoutGroup.vertical(
						layoutSize: itemSize,
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
				CollectionItem(
					id: "action_bonus",
					model: ActionCellViewModel(
						id: "action_bonus",
						title: "Бонусная программа",
						subtitle: "Накапливайте баллы за каждую покупку и обменивайте их на скидки в следующем заказе",
						iconName: "star.fill",
						iconBackgroundColor: .systemPurple
					)
				).erased()
			}
			
			// Модуль 3: "Рекомендуем" — сетка 2 колонки
			CollectionSection(
				id: "recs_module",
				layout: .custom { environment in
					let spacing = LayoutConstants.interItemSpacing
					let containerWidth = environment.container.effectiveContentSize.width
					// Ширина карточки: половина контейнера минус половина отступа между ними
					let cardWidth = (containerWidth - spacing) / 2
					let cardHeight = cardWidth * 1.5

					// Каждая карточка — половина ширины ряда
					let itemSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(0.5),
						heightDimension: .fractionalHeight(1.0)
					)
					let item = NSCollectionLayoutItem(layoutSize: itemSize)

					// Горизонтальный ряд из 2 карточек
					let groupSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1.0),
						heightDimension: .absolute(cardHeight)
					)
					let group = NSCollectionLayoutGroup.horizontal(
						layoutSize: groupSize,
						subitems: [item, item]
					)
					group.interItemSpacing = .fixed(spacing)

					let section = NSCollectionLayoutSection(group: group)
					section.interGroupSpacing = spacing
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
					id: "header_recs",
					model: SectionHeaderViewModel(id: "header_recs", title: "Рекомендуем")
				).erased(),
				decorations: {
					Self.moduleDecoration()
				}
			) {
				CollectionItem(id: "rec_1", model: PromoCardViewModel(id: "rec_1", title: "Смартфон Galaxy", subtitle: "От 29 990 ₽", backgroundColor: .systemIndigo, size: .regular)).erased()
				CollectionItem(id: "rec_2", model: PromoCardViewModel(id: "rec_2", title: "Наушники AirPods", subtitle: "Беспроводные", backgroundColor: .systemTeal, size: .regular)).erased()
				CollectionItem(id: "rec_3", model: PromoCardViewModel(id: "rec_3", title: "Умные часы", subtitle: "Apple Watch S9", backgroundColor: .systemOrange, size: .regular)).erased()
				CollectionItem(id: "rec_4", model: PromoCardViewModel(id: "rec_4", title: "Ноутбук MacBook", subtitle: "Air M2", backgroundColor: .systemPink, size: .regular)).erased()
				CollectionItem(id: "rec_5", model: PromoCardViewModel(id: "rec_5", title: "Планшет iPad", subtitle: "10-го поколения", backgroundColor: .systemGreen, size: .regular)).erased()
				CollectionItem(id: "rec_6", model: PromoCardViewModel(id: "rec_6", title: "Фотоаппарат", subtitle: "Sony A7 IV", backgroundColor: .systemRed, size: .regular)).erased()
				CollectionItem(id: "rec_7", model: PromoCardViewModel(id: "rec_7", title: "Игровая консоль", subtitle: "PlayStation 5", backgroundColor: .systemPurple, size: .regular)).erased()
				CollectionItem(id: "rec_8", model: PromoCardViewModel(id: "rec_8", title: "Робот-пылесос", subtitle: "Xiaomi S10+", backgroundColor: .systemYellow, size: .regular)).erased()
				CollectionItem(id: "rec_9", model: PromoCardViewModel(id: "rec_9", title: "Телевизор QLED", subtitle: "Samsung 55\"", backgroundColor: .systemCyan, size: .regular)).erased()
				CollectionItem(id: "rec_10", model: PromoCardViewModel(id: "rec_10", title: "Колонка HomePod", subtitle: "Apple", backgroundColor: .systemBrown, size: .regular)).erased()
			}

			// Модуль 4: "Доставка продуктов" + товарные баннеры
			CollectionSection(
				id: "delivery_module",
				layout: .custom { environment in
					let containerWidth = environment.container.effectiveContentSize.width
					let bannerWidth = containerWidth * 0.75
					let bannerHeight = bannerWidth * 0.6
					let bannerSize = NSCollectionLayoutSize(
						widthDimension: .fractionalWidth(1),
						heightDimension: .absolute(bannerHeight)
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
