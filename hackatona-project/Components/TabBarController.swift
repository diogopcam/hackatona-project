//
//  TabBarController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController, UITabBarControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialTouchPoint: CGPoint = .zero
    private var dismissThreshold: CGFloat = 120.0 // Distância necessária para fechar
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var backButton: UIButton!
    
    private func setupBackButton() {
            backButton = UIButton(type: .system)
            backButton.setTitle("Voltar", for: .normal)
            backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            backButton.tintColor = .white
            backButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            backButton.layer.cornerRadius = 8
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            backButton.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
            
        // Configuração importante para constraints
               backButton.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(backButton)
               
               // Ativar constraints
               NSLayoutConstraint.activate([
                   backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                   backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                   backButton.heightAnchor.constraint(equalToConstant: 44),
                   backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
               ])
               
               // Garantir que o botão fique na frente
               view.bringSubviewToFront(backButton)
        }
    
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
        
        setupBackButton()

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
        videoPreviewLayer?.videoGravity = .resize
        videoPreviewLayer?.frame = view.layer.bounds
        if let preview = videoPreviewLayer {
            view.layer.addSublayer(preview)
        }
        
        // Adiciona o gesto de swipe
        // Adiciona o gesto de pan (arrastar)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)

        // Inicia a captura
        captureSession?.startRunning()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: view.window)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
            
        case .changed:
            let translation = touchPoint.y - initialTouchPoint.y
            
            // Só anima se for para baixo
            if translation > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation)
            }
            
        case .ended, .cancelled:
            let translation = touchPoint.y - initialTouchPoint.y
            let shouldDismiss = translation > dismissThreshold || velocity.y > 800
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.view.transform = shouldDismiss ?
                    CGAffineTransform(translationX: 0, y: self.view.frame.height) :
                    .identity
            }) { _ in
                if shouldDismiss {
                    self.closeCamera()
                }
            }
            
        default:
            UIView.animate(withDuration: 0.3) {
                self.view.transform = .identity
            }
        }
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            closeCamera()
        }
    }
    
    @objc private func closeCamera() {
         captureSession?.stopRunning()
         videoPreviewLayer?.removeFromSuperlayer()
         backButton.removeFromSuperview()
        
        // Remove o gesto
            if panGestureRecognizer != nil {
                view.removeGestureRecognizer(panGestureRecognizer)
            }
            
            // Reseta a transformação
            view.transform = .identity
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

