//
//  ImageCell.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let statusLabel = UILabel()
    let retryButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        imageView.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.addSubview(imageView)
        
//        deleteButton.frame = CGRect(x: imageView.frame.maxX - 15, y: imageView.frame.minY - 5, width: 20, height: 20)
//        deleteButton.setTitle("X", for: .normal)
//        deleteButton.setTitleColor(.red, for: .normal)
//        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        deleteButton.backgroundColor = .white
//        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
//        deleteButton.layer.borderWidth = 1
//        deleteButton.layer.borderColor = UIColor.red.cgColor
//        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
//        contentView.addSubview(deleteButton)
        
        statusLabel.frame = CGRect(x: 10, y: imageView.frame.maxY + 10, width: frame.width - 20, height: 20) // Centered below the image
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        statusLabel.textColor = .darkText
        contentView.addSubview(statusLabel)
    }
    
//    @objc func deleteImage() {
//        print("Delete button tapped!")
//    }
}
