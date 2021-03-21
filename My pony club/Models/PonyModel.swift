//
//  PonyModel.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 21.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit

struct Pony {
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var ponyImage: String?
    
    static let ponyNames = [
        "Огонек", "Сабудай", "Реви Пеппер", "Контур",
        "Геркулес", "Адам", "Лотос", "Ясон",
        "Хэннеси", "Харлей", "Романтик", "Дик",
        "Восторг", "Поларис", "Дарт Вейдер"
    ]
    
    static func getPonies() -> [Pony] {
        var ponies = [Pony]()
        for pony in ponyNames {
            ponies.append(Pony(name: pony, location: "Измайлово", type: "Пони", image : nil, ponyImage: pony))
        }
        
        return ponies
    }
}
