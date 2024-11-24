//
//  StartViewController.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI()
    }
    
    func configUI(){
        self.view.backgroundColor = .white
        self.setUpStartButton()
    }
    
    func setUpStartButton(){
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Capturing", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 10
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        view.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func startButtonTapped() {
        let cameraVC = CameraViewController()
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
}

