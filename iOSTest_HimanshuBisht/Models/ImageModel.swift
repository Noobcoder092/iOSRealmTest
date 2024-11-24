//
//  ImageModel.swift
//  iOSTest_HimanshuBisht
//
//  Created by Himanshu Bisht on 23/11/24.
//

import Foundation
import RealmSwift

class ImageModel: Object {
    
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var url: String = ""
    @Persisted var name: String = ""
    @Persisted var captureDate: Date = Date()
    @Persisted var uploadStatus: String = "Pending" 
}


