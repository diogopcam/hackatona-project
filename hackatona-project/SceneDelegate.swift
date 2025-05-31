//
//  SceneDelegate.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 30/05/25.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene,
                willConnectTo session: UISceneSession,
                options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let tabBarController = LoginVC()
        window.rootViewController = tabBarController
//        window.rootViewController = rootViewController
//        window.rootViewController = ProductListVC()
        window.makeKeyAndVisible()
     }


    // Os outros métodos podem permanecer como estão...
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
