//
//  CameraViewController.swift
//  hackatona-project
//
//  Created by [Seu Nome] on [Data].
//

import UIKit
import AVFoundation

class CameraVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    lazy var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Falha ao obter o dispositivo da câmera")
            return
        }

        do {
            
            let videoInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Não foi possível adicionar o input à sessão")
                return
            }
        } catch {
            print("Erro ao criar input de vídeo: \(error)")
            return
        }
 
        let captureMetadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Não foi possível adicionar o output")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        if let previewLayer = videoPreviewLayer {
            view.layer.addSublayer(previewLayer)
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            print("🎥 Sessão de captura iniciada")
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
        captureSession.stopRunning()

        
        if let url = URL(string: qrCode), UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abrir Link", style: .default, handler: { _ in
                UIApplication.shared.open(url)
                
                self.captureSession.startRunning()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
                self.captureSession.startRunning()
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.captureSession.startRunning()
            }))
            present(alert, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

