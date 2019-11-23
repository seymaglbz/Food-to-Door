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

class DataManager{
    
    var stores = [Store]()
    var searchedStores = [Store]()
    var isSearching = false
    var searchedStoresNames = [String]()
    let defaults = UserDefaults.standard
    
    var storesCount: Int{
        if isSearching{
            return searchedStores.count
        }else{
            return stores.count
        }
    }
    
    func store(at index: Int) -> Store{
        if isSearching{
            return searchedStores[index]
        }else{
            return stores[index]
        }
    }
    
    func deleteStore(at index: Int){
        stores.remove(at: index)
    }
    
    func saveFavorites(_ storesArray : [Store]){
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(storesArray){
            defaults.set(savedData, forKey: "favoriteStoresArray")
        }
    }
    
    func loadFavorites(){
        DispatchQueue.global(qos: .background).async {
            if let favoriteStores = self.defaults.object(forKey: "favoriteStoresArray") as? Data{
                let jsonDecoder = JSONDecoder()
                do{
                    self.stores = try jsonDecoder.decode([Store].self, from: favoriteStores)
                }catch{
                  print("Couldn't load favorite stores")
                }
            }
        }
    }
    
}
