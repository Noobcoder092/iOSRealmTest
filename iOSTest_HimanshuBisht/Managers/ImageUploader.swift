//
//  ImageUploader.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import Foundation
import RealmSwift
import UIKit


class ImageUploader {
    
    static func uploadImage(imageModel: ImageModel, completion: @escaping (String) -> Void) {
        let imageURL = imageModel.url
        let primaryKey = imageModel.id

        guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: imageURL)) else {
            completion("Failed: Invalid image data")
            return
        }

        let uploadURL = URL(string: "https://www.clippr.ai/api/upload")!
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"

        // Update the status to "Uploading"
        DispatchQueue.global().async {
            let realm = try! Realm()
            if let imageToUpdate = realm.object(ofType: ImageModel.self, forPrimaryKey: primaryKey) {
                try! realm.write {
                    imageToUpdate.uploadStatus = "Uploading"
                }
            }
        }

        // Perform the upload task
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            let realm = try! Realm()

            // Fetch the object using the primary key and update the status
            if let imageToUpdate = realm.object(ofType: ImageModel.self, forPrimaryKey: primaryKey) {
                try! realm.write {
                    if error == nil {
                        imageToUpdate.uploadStatus = "Completed"
                        completion("Completed")
                    } else {
                        imageToUpdate.uploadStatus = "Failed"
                        completion("Failed")
                    }
                }
            } else {
                completion("Failed: Image not found in Realm")
            }
        }

        task.resume()
    }
}






