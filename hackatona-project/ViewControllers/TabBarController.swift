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
        let feedbackVC = FeedbackViewController()
        let feedbackNav = UINavigationController()
        feedbackNav.tabBarItem = UITabBarItem(
            title: "Feedback",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        // Store Tab
        let storeVC = StoreViewController()
        let storeNav = UINavigationController()
        storeNav.tabBarItem = UITabBarItem(
            title: "Loja",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        // Camera Tab
        let cameraVC = CameraViewController()
        let cameraNav = UINavigationController()
        cameraNav.tabBarItem = UITabBarItem(
            title: "Câmera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        
        // Ranking Tab
        let rankingVC = RankingViewController()
        let rankingNav = UINavigationController(rootViewController: rankingVC)
        rankingNav.tabBarItem = UITabBarItem(
            title: "Ranking",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        // Profile Tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Perfil",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [feedbackNav, storeNav, cameraNav, rankingNav, profileNav]
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .white
            tabBar.tintColor = .systemBlue
            tabBar.unselectedItemTintColor = .gray
        }
        
        tabBar.isTranslucent = false
    }
}
