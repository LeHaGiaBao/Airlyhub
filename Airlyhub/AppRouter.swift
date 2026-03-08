//
//  AppRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

enum AppRouter {
    static func createRootModule() -> UIViewController {
        let tabBarController = UITabBarController()

        let exploreViewController = ExploreBuilder.createModule()
        exploreViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_explore", comment: ""),
            image: AssetsIcon.exploreInactive,
            selectedImage: AssetsIcon.exploreActive
        )
        let exploreNavigation = UINavigationController(rootViewController: exploreViewController)

        let flightsViewController = FlightsBuilder.createModule()
        flightsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_flights", comment: ""),
            image: AssetsIcon.flightsInactive,
            selectedImage: AssetsIcon.flightsActive
        )
        let flightsNavigation = UINavigationController(rootViewController: flightsViewController)

        let favoritesViewController = FavoritesBuilder.createModule()
        favoritesViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_favorites", comment: ""),
            image: AssetsIcon.favoritesInactive,
            selectedImage: AssetsIcon.favoritesActive
        )
        let favoritesNavigation = UINavigationController(rootViewController: favoritesViewController)

        let profilesViewController = ProfilesBuilder.build()
        profilesViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_profile", comment: ""),
            image: AssetsIcon.profileInactive,
            selectedImage: AssetsIcon.profileActive
        )
        let profilesNavigation = UINavigationController(rootViewController: profilesViewController)

        tabBarController.viewControllers = [
            exploreNavigation,
            flightsNavigation,
            favoritesNavigation,
            profilesNavigation
        ]
        applyTopShadowToTabBar(tabBarController.tabBar)
        configureTabBarLayout(tabBarController.tabBar)

        return tabBarController
    }
    
    private static func applyTopShadowToTabBar(_ tabBar: UITabBar) {
        let shadowColor = UIColor(
            red: 71 / 255,
            green: 81 / 255,
            blue: 89 / 255,
            alpha: 1
        )

        tabBar.layer.shadowColor = shadowColor.cgColor
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.masksToBounds = false

        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .systemBackground
    }
    
    private static func configureTabBarLayout(_ tabBar: UITabBar) {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground

            let normal = appearance.stackedLayoutAppearance.normal
            let selected = appearance.stackedLayoutAppearance.selected

            normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            
            normal.titleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                .foregroundColor: UIColor.systemGray
            ]
            selected.titleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                .foregroundColor: AppColor.PrimaryColors.Primary.color500 ?? UIColor.systemBlue
            ]

            tabBar.standardAppearance = appearance

            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }

        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(
                top: 6,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
    }
}
