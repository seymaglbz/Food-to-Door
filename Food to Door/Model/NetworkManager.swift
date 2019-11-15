//
//  NetworkManager.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 15.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkManager{

    static let shared = NetworkManager()
    static let baseURL = "https://api.doordash.com/"
    let storeURL = baseURL + "v1/store_search/?"
    let menuURL = baseURL + "v2/restaurant/"
    private init (){}
 
    //MARK: - Store Networking
    func fetchStores(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completed: @escaping ([StoreModel]?)-> Void){
        let urlString = "\(storeURL)lat=\(latitude)&lng=\(longitude)"
        print(urlString)
        if let url = URL(string: urlString){
              let session = URLSession(configuration: .default)
              let task = session.dataTask(with: url){(data, response, error) in
                  if error != nil{
                    return
                  }
                  if let safeData = data{
         
                      if let stores = self.parseStoreJSON(safeData){
                         completed(stores)
                      }
                  }
              }
              task.resume()             
          }
       
    }

    //Bunu initialize ederek yap
    func parseStoreJSON( _ storesData: Data) -> [StoreModel]? {
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
            return nil
        }
    }
    //MARK: - Menu Networking
    func fetchMenu(with id: Int, completed: @escaping ([MenuModel]?)-> Void){
        let urlString = "\(menuURL)\(id)/menu/"
        print(urlString)
              if let url = URL(string: urlString){
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url){(data, response, error) in
                 if error != nil{
                     return
                 }
                 if let safeData = data{
                     if let menus = self.parseMenuJSON(safeData){
                         completed(menus)
                     }
                 }
             }
             task.resume()
         }
    }
    func parseMenuJSON( _ menuData: Data) -> [MenuModel]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([MenuData].self, from: menuData)
            var menusArray = [MenuModel]()
            
            for i in 0..<decodedData.count{
                let title = decodedData[i].menuCategories
                for j in 0..<title.count{
                    let menuTitle = title[j].title
                    let menu = MenuModel(title: menuTitle)
                    menusArray.append(menu)
                }
            }
            return menusArray
        }catch{
            return nil
        }
    }
}
