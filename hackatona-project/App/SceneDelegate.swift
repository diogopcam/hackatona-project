//
//  SceneDelegate.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 30/05/25.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Check if user is logged in
        if let _ = UserDefaults.standard.data(forKey: "logged_user") {
            // User is logged in, show main app
            let tabBar = TabBarController()
            window?.rootViewController = tabBar
        } else {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [LoginVC()]
            window.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }

        if animated {
                UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                    window.rootViewController = vc
                }, completion: nil)
            } else {
                window.rootViewController = vc
            }
        window.rootViewController = vc
    }

    func showLogin() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
        
        // Adiciona uma animação de transição
        if let window = window {
            UIView.transition(with: window,
                            duration: 0.3,
                            options: .transitionCrossDissolve,
                            animations: nil,
                            completion: nil)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
