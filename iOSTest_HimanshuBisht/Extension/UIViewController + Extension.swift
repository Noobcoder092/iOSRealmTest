//
//  UIViewController + Extension.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 24/11/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    private var loaderTag: Int { 999999 }
    
    func showLoader() {
        if view.viewWithTag(loaderTag) != nil {
            return
        }
        
        let loaderContainer = UIView(frame: view.bounds)
        loaderContainer.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loaderContainer.tag = loaderTag
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        loaderContainer.addSubview(activityIndicator)
        view.addSubview(loaderContainer)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loaderContainer.centerYAnchor)
        ])
    }
    
    func hideLoader() {
        if let loaderContainer = view.viewWithTag(loaderTag) {
            loaderContainer.removeFromSuperview()
        }
    }
}
