//
//  StoreManager.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 16.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import CoreLocation

protocol StoreManagerDelegate{
    func didUpdateStores(_ storeManager: StoreManager, stores: [StoreModel])
    func didFailWithError(error: Error)
}

struct StoreManager {
    
    let storeURL = "https://api.doordash.com/v1/store_search/?"
    var delegate: StoreManagerDelegate?
    
    func fetchStores(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(storeURL)lat=\(latitude)&lng=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let stores = self.parseJSON(safeData){
                        self.delegate?.didUpdateStores(self, stores: stores)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON( _ storesData: Data) -> [StoreModel]? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode([StoreData].self, from: storesData)
            var storesArray = [StoreModel]()
            
            for i in 0..<decodedData.count{
                
                let deliveryFee = decodedData[i].deliveryFee
                let id = decodedData[i].id
                let storeImage = decodedData[i].storeImage
                let description = decodedData[i].description
                let storeName = decodedData[i].storeName.name
                if let deliveryTime = decodedData[i].deliveryTime{
                    let store = StoreModel(storeImage: storeImage, storeName: storeName, storeType: description, deliveryFee: deliveryFee, deliveryTime: deliveryTime, storeID: id)
                    storesArray.append(store)
                }else{
                    let store = StoreModel(storeImage: storeImage, storeName: storeName, storeType: description, deliveryFee: deliveryFee, deliveryTime: 0, storeID: id)
                    storesArray.append(store)
                }
            }
            return storesArray
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }    
}
