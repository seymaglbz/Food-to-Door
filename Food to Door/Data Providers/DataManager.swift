//
//  DataManager.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DataManager {    
    var stores: [Store] = []
    var searchedStores: [Store] = []
    var isSearching = false
    var searchedStoresNames: [String] = []
    let defaults = UserDefaults.standard
    var storesCount: Int {
        return isSearching ? searchedStores.count : stores.count
    }
    let favoriteStores = "favoriteStoresArray"
    
    func store(at index: Int) -> Store {
        return isSearching ? searchedStores[index] : stores[index]
    }
    
    func deleteStore(at index: Int) {
        stores.remove(at: index)
    }
    
    func saveFavorites(_ storesArray : [Store]) {
        let jsonEncoder = JSONEncoder()
        guard let savedData = try? jsonEncoder.encode(storesArray) else {return}
        defaults.set(savedData, forKey: favoriteStores)
    }
    
    func loadFavorites() {
        DispatchQueue.global(qos: .background).async {
            guard let favoriteStores = self.defaults.object(forKey: self.favoriteStores) as? Data else {return}
            let jsonDecoder = JSONDecoder()
            do{
                self.stores = try jsonDecoder.decode([Store].self, from: favoriteStores)
            }catch{
                print("Couldn't load favorite stores")
            }
        }
    }
}
