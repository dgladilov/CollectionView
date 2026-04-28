//
//  TabBarController.swift
//  CollectionView
//
//  Created by Дмитрий on 24.04.2026.
//

import UIKit

final class TabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let firstVC = FirstViewController()
		firstVC.tabBarItem = UITabBarItem(title: "First", image: UIImage(systemName: "1.circle"), tag: 0)

		let secondVC = SecondViewController()
		secondVC.tabBarItem = UITabBarItem(title: "Second", image: UIImage(systemName: "2.circle"), tag: 1)

		let thirdVC = ThirdViewController()
		thirdVC.tabBarItem = UITabBarItem(title: "Third", image: UIImage(systemName: "3.circle"), tag: 2)

		viewControllers = [firstVC, secondVC, thirdVC]
	}
}
