//
//  ImageListViewController.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import UIKit
import RealmSwift

class ImageListViewController: UIViewController{
    
    var collectionView: UICollectionView!
    var images: Results<ImageModel>!
    private let uploadImagesButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUploadButton()
        setupCollectionView()
        loadImages()
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: uploadImagesButton.topAnchor, constant: -20)
        ])
    }
    
    func setUpUploadButton(){
        uploadImagesButton.setTitle("Upload Images", for: .normal)
        uploadImagesButton.backgroundColor = .systemRed
        uploadImagesButton.setTitleColor(.white, for: .normal)
        uploadImagesButton.layer.cornerRadius = 10
        uploadImagesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        uploadImagesButton.translatesAutoresizingMaskIntoConstraints = false
        uploadImagesButton.addTarget(self, action: #selector(uploadAllImages), for: .touchUpInside)
        self.view.addSubview(uploadImagesButton)
        
        NSLayoutConstraint.activate([
            uploadImagesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadImagesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            uploadImagesButton.heightAnchor.constraint(equalToConstant: 50),
            uploadImagesButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setUpFullScreenImageView(_ indexPath : IndexPath){
        guard let window = UIApplication.shared.keyWindow else { return }

        let fullScreenView = UIView(frame: window.bounds)
        fullScreenView.backgroundColor = .black
        fullScreenView.tag = 999
        
        let scrollView = UIScrollView(frame: fullScreenView.bounds)
        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self

        let fullScreenImageView = UIImageView(frame: scrollView.bounds)
        fullScreenImageView.contentMode = .scaleAspectFit
        if let image = UIImage(contentsOfFile: images[indexPath.item].url) {
            fullScreenImageView.image = image
        }
        fullScreenImageView.isUserInteractionEnabled = true
        scrollView.addSubview(fullScreenImageView)

        fullScreenView.addSubview(scrollView)

        let closeButton = UIButton(frame: CGRect(x: 16, y: 60, width: self.view.bounds.width - 40, height: 44))
        closeButton.layer.cornerRadius = 8.0
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = .brown
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeFullScreenView), for: .touchUpInside)
        fullScreenImageView.addSubview(closeButton)

        window.addSubview(fullScreenView)
        
    }
    
    func loadImages() {
        let realm = try! Realm()
        images = realm.objects(ImageModel.self)
        collectionView.reloadData()
    }
    

    @objc private func uploadAllImages() {
        guard !images.isEmpty else {
            print("No images to upload")
            return
        }
        
        self.showLoader()
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            
            ImageUploader.uploadImage(imageModel: image) { status in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.hideLoader()
            print("All uploads completed!")
        }
    }

    @objc func dismissFullScreenView(_ gesture: UITapGestureRecognizer) {
        gesture.view?.removeFromSuperview()
    }
    
    @objc private func closeFullScreenView() {
        if let fullScreenView = UIApplication.shared.keyWindow?.subviews.last {
            fullScreenView.removeFromSuperview()
        }
    }
}

extension ImageListViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageModel = images[indexPath.row]
        if let image = UIImage(contentsOfFile: imageModel.url) {
            cell.imageView.image = image
        }
        cell.statusLabel.text = imageModel.uploadStatus
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setUpFullScreenImageView(indexPath)
    }
}

extension ImageListViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first(where: { $0 is UIImageView })
    }
}
