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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

//        Persistance.clearUsers()
//        Persistance.saveUser(User(name: "Test User", email: "email", password: "password"))
        
        
        if let _ = Persistence.getLoggedUser() {
            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
        } else {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [LoginViewController()]
            window.rootViewController = navigationController
        }

        self.window = window
        
        window.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        if animated {
                UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                    window.rootViewController = vc
                }, completion: nil)
            } else {
                window.rootViewController = vc
            }
        // pesquisar coordinator - animacoes
        window.rootViewController = vc
    }

    // Os outros métodos podem permanecer como estão...
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
