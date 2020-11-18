//
//  MainTabBarController.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 20.10.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
        tabBar.standardAppearance = appearance
        
        let mainVC = createViewController(viewController: MainController(), image: UIImage(named: "Main")!, navigationTitle: "Водный баланс", tabBarTitle: "Главная")
        let historyVC = createViewController(viewController: HistoryController(), image: UIImage(named: "History")!, navigationTitle: "История", tabBarTitle: "История")
        let statisticsVC = createViewController(viewController: StatisticsController(), image: UIImage(named: "Statistics")!, navigationTitle: "Статистика", tabBarTitle: "Статистика")
        let achievementsVC = createViewController(viewController: AchievementsController(), image: UIImage(named: "Achievements")!, navigationTitle: "Достижения", tabBarTitle: "Достижения")
        let settingsVC = createViewController(viewController: SettingsController(), image: UIImage(named: "Settings")!, navigationTitle: "Настройки", tabBarTitle: "Настройки")
        
        viewControllers = [mainVC, historyVC, statisticsVC, achievementsVC, settingsVC]
    }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .lightMenu()
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightMenu()]
        
        itemAppearance.selected.iconColor = .mainDark()
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainDark()]
    }
    
    private func createViewController<T: UIViewController>(viewController: T, image: UIImage, navigationTitle: String, tabBarTitle: String) -> UINavigationController {
        let identifier = String(describing: T.self)
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: identifier) as! T
        viewController.navigationItem.title = navigationTitle
        viewController.tabBarItem.title = tabBarTitle
        viewController.tabBarItem.image = image
        let navigationVC = UINavigationController(rootViewController: viewController)
        return navigationVC
    }
    
}
