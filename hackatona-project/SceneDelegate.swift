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
        // 1. Verifique se a cena é do tipo UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Crie uma window programaticamente
        window = UIWindow(windowScene: windowScene)
        
        // 3. Defina sua ViewController como rootViewController
        window?.rootViewController = ViewController() // ← Sua ViewController em ViewCode
        
        // 4. Torne a window visível e principal
        window?.makeKeyAndVisible()
    }

    // Os outros métodos podem permanecer como estão...
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
