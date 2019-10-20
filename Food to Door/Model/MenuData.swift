//
//  MenuData.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

struct MenuData: Codable{
    
    let menuCategories: [Category]
    
    enum CodingKeys: String, CodingKey{
        case menuCategories = "menu_categories"
    }
}

struct Category: Codable{
    let title: String    
}

