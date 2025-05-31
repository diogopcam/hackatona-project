//
//  CameraViewController.swift
//  hackatona-project
//
//  Created by [Seu Nome] on [Data].
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Obter a câmera traseira para capturar vídeos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Falha ao obter o dispositivo da câmera")
            return
        }

        do {
            // Obter o input da câmera
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

        // Criar o output de metadata (QR code)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)

            // Setar delegate para capturar códigos
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Não foi possível adicionar o output")
            return
        }
        
        

        // Visualização da câmera
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

    // MARK: - Delegate para captura de QR Code
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let qrCode = metadataObject.stringValue else {
            return
        }

        print("📷 QR Code detectado: \(qrCode)")

        // Parar a sessão para evitar múltiplas leituras
        captureSession.stopRunning()

        // Verificar se o qrCode é uma URL válida
        if let url = URL(string: qrCode), UIApplication.shared.canOpenURL(url) {
            // Mostrar alerta com botão para abrir o link
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abrir Link", style: .default, handler: { _ in
                UIApplication.shared.open(url)
                // Opcional: reiniciar a captura
                self.captureSession.startRunning()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
                self.captureSession.startRunning()
            }))
            present(alert, animated: true)
        } else {
            // Se não for URL válida, mostrar apenas o texto
            let alert = UIAlertController(title: "QR Code detectado",
                                          message: qrCode,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.captureSession.startRunning()
            }))
            present(alert, animated: true)
        }
    }


    // Encerrar sessão ao sair da tela
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
