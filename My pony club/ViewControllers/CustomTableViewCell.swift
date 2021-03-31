//
//  CustomTableViewCell.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 19.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var imageOfPony: UIImageView! {
        didSet {
            imageOfPony.layer.cornerRadius = imageOfPony.frame.size.height / 2
            imageOfPony.clipsToBounds = true
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
}
