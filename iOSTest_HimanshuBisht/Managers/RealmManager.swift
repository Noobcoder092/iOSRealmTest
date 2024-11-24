//
//  RealmManager.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import Foundation
import UIKit
import RealmSwift


class RealmManager {
    
    static func saveImageToRealm(_ image: UIImage) {
        let fileName = "\(UUID().uuidString).jpg"
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: filePath)
            
            let realm = try Realm()
            let imageModel = ImageModel()
            imageModel.url = filePath.path
            imageModel.name = fileName
            try realm.write {
                realm.add(imageModel)
            }
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
