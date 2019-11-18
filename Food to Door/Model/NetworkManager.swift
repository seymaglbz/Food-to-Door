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
    func fetchStores(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completed: @escaping ([Store]?)-> Void){
        let urlString = "\(storeURL)lat=\(latitude)&lng=\(longitude)"
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil{
                    return
                }
                if let safeData = data{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: safeData, options: [])
                        var storeArray = [Store]()
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                        for i in 0..<jsonArray.count{
                            let store = Store(data: jsonArray[i])
                            storeArray.append(store)
                        }
                        completed(storeArray)
                    }catch{
                        print("Couldn't parse JSON")
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Menu Networking
    func fetchMenu(with id: Int, completed: @escaping ([String]?)-> Void){
        let urlString = "\(menuURL)\(id)/menu/"
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil{
                    return
                }
                if let safeData = data{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: safeData, options: [])
                        var menuTitles = [String]()
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                        for i in 0..<jsonArray.count{
                            let menu = Menu(data: jsonArray[i])
                            if let menuCategories = menu.menuCategories{
                                for j in 0..<menuCategories.count{
                                    let title = menuCategories[j].title
                                    menuTitles.append(title)
                                }
                            }
                        }
                        completed(menuTitles)
                    }catch{
                        print("Couldn't parse JSON")
                    }
                }
            }
            task.resume()
        }
    }
}
