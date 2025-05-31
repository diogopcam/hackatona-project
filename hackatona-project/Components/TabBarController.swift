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
        backButton.setTitle("Fechar", for: .normal)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backButton.layer.cornerRadius = 20 // Botão mais redondo
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
        
        // Adiciona padding interno
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        // Atualiza as constraints para posicionar no topo direito
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Adiciona sombra para melhor visibilidade
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowRadius = 4
        backButton.layer.shadowOpacity = 0.3
        
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
            image: UIImage(systemName: "storefront"),
            selectedImage: UIImage(systemName: "storefront.fill")
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
            image: UIImage(systemName: "medal"),
            selectedImage: UIImage(systemName: "medal.fill")
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
        // Se tentar selecionar a tab da câmera
        if viewController == viewControllers?[2] {
            openCamera()
            return false
        }
        
        // Se a câmera estiver aberta, fecha antes de trocar de tab
        if captureSession != nil {
            closeCamera()
        }
        
        return true
    }
    
    private func openCamera() {
        // Previne múltiplas aberturas
        guard captureSession == nil else { return }
        
        // Salva o estado atual da tabBar
        let wasTabBarHidden = tabBar.isHidden
        
        // Cria uma nova view para a câmera
        let cameraView = UIView(frame: view.bounds)
        cameraView.tag = 999 // Tag para identificar a view da câmera
        cameraView.backgroundColor = .black
        view.addSubview(cameraView)
        
        // Esconde a tabBar durante o uso da câmera
        tabBar.isHidden = true
        
        // Configura a nova sessão
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(title: "Erro", message: "Câmera não disponível")
            cleanupCameraView()
            tabBar.isHidden = wasTabBarHidden
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              (captureSession?.canAddInput(videoInput) ?? false) else {
            showAlert(title: "Erro", message: "Não foi possível acessar a câmera")
            cleanupCameraView()
            tabBar.isHidden = wasTabBarHidden
            return
        }

        captureSession?.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession?.canAddOutput(metadataOutput) ?? false {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(title: "Erro", message: "Não foi possível configurar a leitura de QR Code")
            cleanupCameraView()
            tabBar.isHidden = wasTabBarHidden
            return
        }

        // Configura a visualização da câmera
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = cameraView.bounds
        
        if let preview = videoPreviewLayer {
            cameraView.layer.addSublayer(preview)
        }
        
        // Adiciona os controles de UI
        setupBackButton()
        
        // Adiciona o gesto de pan
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        cameraView.addGestureRecognizer(panGestureRecognizer!)
        
        // Adiciona um tap gesture para focar a câmera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
        cameraView.addGestureRecognizer(tapGesture)

        // Inicia a captura em background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func cleanupCameraView() {
        view.viewWithTag(999)?.removeFromSuperview()
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
        // Desabilita interações durante o fechamento
        view.isUserInteractionEnabled = false
        
        // Para a sessão em background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession?.stopRunning()
            
            DispatchQueue.main.async {
                // Remove gestos primeiro
                if let panGesture = self.panGestureRecognizer {
                    self.view.removeGestureRecognizer(panGesture)
                    self.panGestureRecognizer = nil
                }
                
                // Remove o botão
                self.backButton?.removeFromSuperview()
                self.backButton = nil
                
                // Remove a view da câmera e limpa a layer de preview
                self.cleanupCameraView()
                self.videoPreviewLayer = nil
                
                // Limpa a sessão
                self.captureSession = nil
                
                // Reseta a transformação da view
                self.view.transform = .identity
                
                // Mostra a tabBar novamente
                self.tabBar.isHidden = false
                
                // Força a atualização da UI
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                // Reabilita interações
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func handleTapToFocus(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        guard let previewLayer = videoPreviewLayer else { return }
        
        let devicePoint = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        
        focus(at: devicePoint)
    }
    
    private func focus(at devicePoint: CGPoint) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported {
                device.focusPointOfInterest = devicePoint
                device.focusMode = .autoFocus
            }
            
            if device.isExposurePointOfInterestSupported {
                device.exposurePointOfInterest = devicePoint
                device.exposureMode = .autoExpose
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error configuring focus: \(error.localizedDescription)")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let qrCode = metadataObject.stringValue else {
            return
        }

        print("📷 QR Code detected: \(qrCode)")
        captureSession?.stopRunning()

        // Verifica se é uma URL do nosso app
        if let url = URL(string: qrCode) {
            let urlString = url.absoluteString.lowercased()
            
            // Fecha a câmera primeiro
            closeCamera()
            
            // Navega para a tela apropriada baseado na URL
            if urlString.contains("feedback") {
                // Navega para a tela de feedback
                self.selectedIndex = 0 // índice da tab de feedback
            } else if urlString.contains("store") {
                // Navega para a loja
                self.selectedIndex = 1 // índice da tab de loja
            } else if urlString.contains("ranking") {
                // Navega para o ranking
                self.selectedIndex = 3 // índice da tab de ranking
            } else if urlString.contains("profile") {
                // Navega para o perfil
                self.selectedIndex = 4 // índice da tab de perfil
            } else if UIApplication.shared.canOpenURL(url) {
                // Se for uma URL externa válida
                let alert = UIAlertController(title: "QR Code detected",
                                              message: qrCode,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Open Link", style: .default, handler: { _ in
                    UIApplication.shared.open(url)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "QR Code detected",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            
            appearance.stackedLayoutAppearance.selected.iconColor = .mainGreen
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.mainGreen]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .white
            tabBar.tintColor = .mainGreen
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

