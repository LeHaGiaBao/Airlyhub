//
//  AppRouter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 27/12/2025.
//

import UIKit

enum AppRouter {
    static func setRootToMainTab(in window: UIWindow) {
        window.rootViewController = createRootModule(nav: UINavigationController())
    }

    /// Rebuilds the window's root view controller (respecting auth state) with a
    /// cross-dissolve. Used after a global change such as switching the app language,
    /// where every already-loaded screen must be recreated to pick up the new locale.
    /// Restores the previously selected tab so the user stays in the same section.
    static func reloadRoot(in window: UIWindow, selectedTab: Int? = nil) {
        if AppContainer.shared.authRepository.isLoggedIn() {
            let root = createRootModule(nav: UINavigationController())
            if let selectedTab,
               let tabBar = root as? UITabBarController,
               selectedTab < (tabBar.viewControllers?.count ?? 0) {
                tabBar.selectedIndex = selectedTab
            }
            window.rootViewController = root
        } else {
            setRootToLogin(in: window)
        }
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }

    static func setRootToLogin(in window: UIWindow) {
        let login = LoginBuilder().build()
        window.rootViewController = UINavigationController(rootViewController: login)
    }
    
    static func setRootToRegister(in window: UIWindow) {
        let register = RegisterBuilder().build()
        window.rootViewController = UINavigationController(rootViewController: register)
    }

    /// - Parameter nav: the Profiles tab's stack. Each tab needs its own — they were
    ///   sharing one, which meant whichever builder ran last claimed it and pushes
    ///   from the other tabs landed in a stack the user wasn't looking at.
    static func createRootModule(nav: UINavigationController) -> UIViewController {
        let tabBarController = UITabBarController()

        let exploreNavigation = ExploreBuilder().build(nav: UINavigationController())
        exploreNavigation.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_explore", comment: ""),
            image: AssetsIcon.exploreInactive,
            selectedImage: AssetsIcon.exploreActive
        )

        let flightsNavigation = FlightsBuilder().build(nav: UINavigationController())
        flightsNavigation.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_flights", comment: ""),
            image: AssetsIcon.flightsInactive,
            selectedImage: AssetsIcon.flightsActive
        )

        let favoritesNavigation = FavoritesBuilder().build(nav: UINavigationController())
        favoritesNavigation.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_favorites", comment: ""),
            image: AssetsIcon.favoritesInactive,
            selectedImage: AssetsIcon.favoritesActive
        )
        
        let profilesNavigation = ProfilesBuilder().build(nav: nav)
        profilesNavigation.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab_profile", comment: ""),
            image: AssetsIcon.profileInactive,
            selectedImage: AssetsIcon.profileActive
        )
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
