//
//  StoreModel.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 16.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

struct StoreModel: Codable{
    
    let storeImage: String
    let storeName: String
    let storeType: String
    let deliveryFee: Int
    let deliveryTime: Int
    let storeID: Int
    
}
