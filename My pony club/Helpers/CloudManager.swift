//
//  CloudManager.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 31.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit
import CloudKit

class CloudManager {
    
    private static let privateCloudDatabase = CKContainer.default().publicCloudDatabase
    
    static func saveDataToCloud(pony: Pony, with image: UIImage) {
        
        let (image, url) = prepareImageToSaveToCloud(pony: pony, image: image)
        
        guard let imageAsset = image , let imageURL = url else { return }
        
        let record = CKRecord(recordType: "Pony")
        record.setValue(pony.name, forKey: "name")
        record.setValue(pony.location, forKey: "location")
        record.setValue(pony.type, forKey: "type")
        record.setValue(pony.rating, forKey: "rating")
        record.setValue(imageAsset, forKey: "imageData")
        
        privateCloudDatabase.save(record) { (_, error) in
            if let error = error { print(error); return}
            deleteTempImage(imageURL: imageURL)
        }
    }
    
    static func fetchDataFromCloud(closure: @escaping (Pony) -> ()) {
        
        let query = CKQuery(recordType: "Pony", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard error == nil else { print(error!); return }
            guard let records = records else { return }
            
            records.forEach { (record) in
                
                let newPony = Pony(record: record)
                
                DispatchQueue.main.async {
                    closure(newPony)
                }
            }
        }
        
    }
    
    // MARK: Private Methods
    
    private static func prepareImageToSaveToCloud(pony: Pony, image: UIImage) -> (CKAsset?, URL?) {
        
        let scale = image.size.width > 1080 ? 1080 / image.size.width : 1
        let scaleImage = UIImage(data: image.pngData()!, scale: scale)
        let imageFilePath = NSTemporaryDirectory() + pony.name
        let imageURL = URL(fileURLWithPath: imageFilePath)
        
        guard let dataToPath = scaleImage?.jpegData(compressionQuality: 1) else { return (nil, nil)}
        
        do {
            try dataToPath.write(to: imageURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        let imageAsset = CKAsset(fileURL: imageURL)
        
        return (imageAsset, imageURL)
    }
    
    static private func deleteTempImage(imageURL: URL) {
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
