//
//  StoreData.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 16.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

struct StoreData: Codable{
    
    let deliveryFee: Int
    let id: Int
    let deliveryTime: Int?
    let storeImage: String
    let description: String
    let storeName: Business
    
    enum CodingKeys: String, CodingKey{
        case deliveryFee = "delivery_fee"
        case id = "id"
        case deliveryTime = "asap_time"
        case storeImage = "cover_img_url"
        case description = "description"
        case storeName = "business"
    }
}

struct Business: Codable{
    let name: String
}
