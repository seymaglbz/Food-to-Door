//
//  Store.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 17.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

struct Store: Codable{
    
    var storeImage: String
    var storeType: String
    var deliveryFee: Int?
    var deliveryTime: Int?
    var storeID: Int
    var storeName: Business!
    
    init(data: [String: Any]){
        storeImage = data["cover_img_url"] as! String
        storeType = data["description"] as! String
        deliveryFee = data["delivery_fee"] as? Int ?? 0
        deliveryTime = data["asap_time"] as? Int ?? 0
        storeID = data["id"] as! Int
        storeName = parseStoreName(data: data)
    }
    
    func parseStoreName(data:[String: Any]) -> Business{
        let storeName = data["business"] as! [String: Any]
        return Business(data: storeName)
    }
}

struct Business: Codable{
    let name: String
    
    init(data: [String: Any]){
        name = data["name"] as! String
    }
}

