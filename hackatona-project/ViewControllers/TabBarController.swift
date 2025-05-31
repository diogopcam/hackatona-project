//
//  TabBarController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//


//
//  TabBarController.swift
//  purrchase
//
//  Created by Diogo Camargo on 13/05/25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        // Feedback Tab
        let feedbackVC = UIViewController() // Replace with your actual Feedback ViewController
        let feedbackNav = UINavigationController(rootViewController: feedbackVC)
        feedbackNav.tabBarItem = UITabBarItem(
            title: "Feedback",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        // Store Tab
        let storeVC = UIViewController() // Replace with your actual Store ViewController
        let storeNav = UINavigationController(rootViewController: storeVC)
        storeNav.tabBarItem = UITabBarItem(
            title: "Store",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        // Camera Tab (Center prominent item)
        let cameraVC = UIViewController() // Replace with your actual Camera ViewController
        let cameraNav = UINavigationController(rootViewController: cameraVC)
        cameraNav.tabBarItem = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        
        // Ranking Tab
        let rankingVC = UIViewController() // Replace with your actual Ranking ViewController
        let rankingNav = UINavigationController(rootViewController: rankingVC)
        rankingNav.tabBarItem = UITabBarItem(
            title: "Ranking",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        // Profile Tab
        let profileVC = UIViewController() // Replace with your actual Profile ViewController
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [feedbackNav, storeNav, cameraNav, rankingNav, profileNav]
    }
    
    private func setupTabBarAppearance() {
        // Set white background
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            // Selected item appearance
            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            
            // Unselected item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback for earlier iOS versions
            tabBar.barTintColor = .white
            tabBar.tintColor = .systemBlue
            tabBar.unselectedItemTintColor = .gray
        }
        
        // Make the tab bar opaque
        tabBar.isTranslucent = false
    }
}
