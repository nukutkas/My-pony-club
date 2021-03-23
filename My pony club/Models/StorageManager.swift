//
//  StorageManager.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 23.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ pony: Pony) {
        try! realm.write {
            realm.add(pony)
        }
    }
    
    static func deleteObject(_ pony: Pony) {
        
        try! realm.write {
            realm.delete(pony)
        }
    }
    
}
