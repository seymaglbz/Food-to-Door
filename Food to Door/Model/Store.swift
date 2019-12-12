//
//  Store.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 17.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

struct Store: Codable {
    var image: String
    var type: String
    var deliveryFee: Int?
    var deliveryTime: Int?
    var id: Int
    var business: Business!
    
    init(data: [String: Any]) {
        image = data["cover_img_url"] as! String
        type = data["description"] as! String
        deliveryFee = data["delivery_fee"] as? Int ?? 0
        deliveryTime = data["asap_time"] as? Int ?? 0
        id = data["id"] as! Int
        business = parseStoreName(data: data)
    }
    
    func parseStoreName(data:[String: Any]) -> Business {
        let storeName = data["business"] as! [String: Any]
        return Business(data: storeName)
    }
}

struct Business: Codable {
    let name: String
    
    init(data: [String: Any]){
        name = data["name"] as! String
    }
}

