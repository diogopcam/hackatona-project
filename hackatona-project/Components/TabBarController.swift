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
    private var dismissThreshold: CGFloat = 120.0
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var backButton: UIButton!
    
    private func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("Fechar", for: .normal)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.tintColor = .labelPrimary
        backButton.backgroundColor = UIColor.backgroundTertiary
        backButton.layer.cornerRadius = 20 
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
        
        backButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
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
        let feedbackVC = FeedbackVC()
        let feedbackNav = UINavigationController(rootViewController: feedbackVC)
        feedbackNav.tabBarItem = UITabBarItem(
            title: "Feedback",
            image: UIImage(systemName: "text.bubble"),
            selectedImage: UIImage(systemName: "text.bubble.fill")
        )
        
        let storeVC = StoreVC()
        let storeNav = UINavigationController(rootViewController: storeVC)
        storeNav.tabBarItem = UITabBarItem(
            title: "Store",
            image: UIImage(systemName: "storefront"),
            selectedImage: UIImage(systemName: "storefront.fill")
        )
        
        let cameraItem = UITabBarItem(
            title: "QR Code",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        
        let rankingVC = RankingVC()
        let rankingNav = UINavigationController(rootViewController: rankingVC)
        rankingNav.tabBarItem = UITabBarItem(
            title: "Ranking",
            image: UIImage(systemName: "medal"),
            selectedImage: UIImage(systemName: "medal.fill")
        )
        
        let profileVC = ProfileVC()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        let emptyVC = UIViewController()
        emptyVC.tabBarItem = cameraItem
        
        viewControllers = [feedbackNav, storeNav, emptyVC, rankingNav, profileNav]
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == viewControllers?[2] {
            openCamera()
            return false
        }
        
        if captureSession != nil {
            closeCamera()
        }
        
        return true
    }
    
    private func openCamera() {
        guard captureSession == nil else { return }
        
        let wasTabBarHidden = tabBar.isHidden
        
        let cameraView = UIView(frame: view.bounds)
        cameraView.tag = 999
        cameraView.backgroundColor = .backgroundPrimary
        view.addSubview(cameraView)
        
        tabBar.isHidden = true
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            cleanupCameraView()
            tabBar.isHidden = wasTabBarHidden
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              (captureSession?.canAddInput(videoInput) ?? false) else {
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
            cleanupCameraView()
            tabBar.isHidden = wasTabBarHidden
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = cameraView.bounds
        
        if let preview = videoPreviewLayer {
            cameraView.layer.addSublayer(preview)
        }
        
        setupBackButton()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        cameraView.addGestureRecognizer(panGestureRecognizer!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
        cameraView.addGestureRecognizer(tapGesture)

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
        view.isUserInteractionEnabled = false

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession?.stopRunning()
            
            DispatchQueue.main.async {
                if let panGesture = self.panGestureRecognizer {
                    self.view.removeGestureRecognizer(panGesture)
                    self.panGestureRecognizer = nil
                }
                
                self.backButton?.removeFromSuperview()
                self.backButton = nil
                
                self.cleanupCameraView()
                self.videoPreviewLayer = nil
                
                self.captureSession = nil
                
                self.view.transform = .identity
                
                self.tabBar.isHidden = false
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
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
        
        if let url = URL(string: qrCode) {
            let urlString = url.absoluteString.lowercased()

            closeCamera()
            
            if urlString.contains("feedback") {
                self.selectedIndex = 0
                
            } else if urlString.contains("store") {
                self.selectedIndex = 1
                
            } else if urlString.contains("ranking") {
                self.selectedIndex = 3
                
            } else if urlString.contains("profile") {
                self.selectedIndex = 4
                
            } else if UIApplication.shared.canOpenURL(url) {
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
            appearance.backgroundColor = .backgroundSecondary
            
            appearance.stackedLayoutAppearance.selected.iconColor = .mainGreen
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.mainGreen]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .labelPrimary
            tabBar.tintColor = .mainGreen
            tabBar.unselectedItemTintColor = .gray
        }
        
        tabBar.isTranslucent = false
    }
}

extension TabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // Aqui você pode processar a imagem capturada
        // Por exemplo, salvar ou enviar para outro view controller
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
