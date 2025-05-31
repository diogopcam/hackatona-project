//
//  TabBarController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit
import UIKit
import AVFoundation

class TabBarController: UITabBarController, UITabBarControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
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
        // Configura a sessão de captura
        captureSession = AVCaptureSession()

        // Obtem a câmera traseira
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(title: "Erro", message: "Câmera não disponível")
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              (captureSession?.canAddInput(videoInput) ?? false) else {
            showAlert(title: "Erro", message: "Não foi possível acessar a câmera")
            return
        }

        captureSession?.addInput(videoInput)

        // Configura a saída para ler QR Codes
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession?.canAddOutput(metadataOutput) ?? false {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(title: "Erro", message: "Não foi possível adicionar saída de metadados")
            return
        }

        // Adiciona a visualização da câmera na tela
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        if let preview = videoPreviewLayer {
            view.layer.addSublayer(preview)
        }

        // Inicia a captura
        captureSession?.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let qrCode = metadataObject.stringValue else {
            return
        }

        print("📷 QR Code detectado: \(qrCode)")

        captureSession?.stopRunning()

        if let url = URL(string: qrCode), UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abrir Link", style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                self.captureSession!.startRunning()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
                self.captureSession!.startRunning()
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.captureSession!.startRunning()
            }))
            present(alert, animated: true)
        }
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

extension TabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let _ = info[.originalImage] as? UIImage else {
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
