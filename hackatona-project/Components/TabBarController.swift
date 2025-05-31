//
//  TabBarController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
        self.delegate = self
    }
    
    private func setupTabs() {
        let feedbackVC = FeedbackViewController()
        let feedbackNav = UINavigationController(rootViewController: feedbackVC)
        feedbackNav.tabBarItem = UITabBarItem(
            title: "Feedback",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        let storeVC = StoreViewController()
        let storeNav = UINavigationController(rootViewController: storeVC)
        storeNav.tabBarItem = UITabBarItem(
            title: "Loja",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        // Não precisamos de um view controller real para a câmera
        let cameraItem = UITabBarItem(
            title: "Câmera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        
        let rankingVC = RankingViewController()
        let rankingNav = UINavigationController(rootViewController: rankingVC)
        rankingNav.tabBarItem = UITabBarItem(
            title: "Ranking",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Perfil",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // Criamos um view controller vazio apenas para o item da tab bar
        let emptyVC = UIViewController()
        emptyVC.tabBarItem = cameraItem
        
        viewControllers = [feedbackNav, storeNav, emptyVC, rankingNav, profileNav]
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == viewControllers?[2] { // Índice do item da câmera
            openCamera()
            return false
        }
        return true
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Error", message: "Camera not available")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self // Certifique-se de que TabBarController implementa os protocolos necessários
        present(imagePicker, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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

// Extensão para lidar com os resultados do image picker
extension TabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "Failed to capture image")
            return
        }
        
        // Aqui você pode processar a imagem capturada
        // Por exemplo, salvar ou enviar para outro view controller
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
