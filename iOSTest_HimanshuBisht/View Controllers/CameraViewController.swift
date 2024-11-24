//
//  CameraViewController.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import UIKit
import AVFoundation
import RealmSwift

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturedImages: [UIImage] = []
    
    private let captureButton = UIButton(type: .system)
    private let showImagesButton = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCamera()
        self.setupButtons()
        self.setupStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateButtonLayout()           // I Used it to delete the existing uploads
//        let realm = try! Realm()
//        let completedImages = realm.objects(ImageModel.self)
//        try! realm.write {
//            realm.delete(completedImages)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        
        captureSession.addInput(input)
        
        photoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(photoOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
                   self.captureSession?.startRunning()
        }
    }
    
    private func setupButtons() {
        captureButton.setTitle("Capture", for: .normal)
        captureButton.backgroundColor = .blue
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.layer.cornerRadius = 10
        captureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        captureButton.titleLabel?.adjustsFontSizeToFitWidth = true
        captureButton.titleLabel?.minimumScaleFactor = 0.5
        captureButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(captureButton)
        
        showImagesButton.setTitle("Show Images", for: .normal)
        showImagesButton.backgroundColor = .green
        showImagesButton.setTitleColor(.white, for: .normal)
        showImagesButton.layer.cornerRadius = 10
        showImagesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        showImagesButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showImagesButton.titleLabel?.minimumScaleFactor = 0.5
        showImagesButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        showImagesButton.addTarget(self, action: #selector(showCapturedImages), for: .touchUpInside)
        showImagesButton.isHidden = true
        view.addSubview(showImagesButton)
    }
    
    private func setupStackView() {
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
        buttonStackView.spacing = 20
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(captureButton)
        buttonStackView.addArrangedSubview(showImagesButton)
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateButtonLayout() {
        if capturedImages.count == 0 {
            showImagesButton.isHidden = true
            buttonStackView.spacing = 0
            buttonStackView.alignment = .center
        }
        else {
            showImagesButton.isHidden = false
            buttonStackView.spacing = 20
            buttonStackView.alignment = .fill
        }
    }
    
    @objc private func capturePhoto() {
        print("Captured Images count >>>> \(capturedImages.count + 1)")
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc private func showCapturedImages() {
        let imageListVC = ImageListViewController()
        self.navigationController?.pushViewController(imageListVC, animated: true)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        capturedImages.append(image)
        RealmManager.saveImageToRealm(image)
        updateButtonLayout()
    }
}

