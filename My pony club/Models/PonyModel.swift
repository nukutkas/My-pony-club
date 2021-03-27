//
//  PonyModel.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 21.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import RealmSwift

class Pony: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(name: String, location: String?, type: String, imageData: Data?, rating: Double ) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.rating = rating
    }
    
}
