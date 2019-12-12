//
//  NetworkManager.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 15.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkManager {
    
    static let shared = NetworkManager()
    static let baseURL = "https://api.doordash.com/"
    let storeURL = baseURL + "v1/store_search/?"
    let menuURL = baseURL + "v2/restaurant/"
    private init (){}
    
    //MARK: - Store Networking
    func fetchStores(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completed: @escaping ([Store]?)-> Void) {
        let urlString = "\(storeURL)lat=\(latitude)&lng=\(longitude)"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        print(urlString)
        
        let task = session.dataTask(with: url){(data, response, error) in
            guard error == nil else {return}
            guard let safeData = data else {return}
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: safeData, options: [])
                var storeArray: [Store] = []
                guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                
                for i in 0..<jsonArray.count{
                    let store = Store(data: jsonArray[i])
                    storeArray.append(store)
                }
                completed(storeArray)
            } catch {
                print("Couldn't parse JSON")
            }
        }
        task.resume()
    }
    
    //MARK: - Menu Networking
    func fetchMenu(with id: Int, completed: @escaping ([String]?)-> Void) {
        let urlString = "\(menuURL)\(id)/menu/"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        print(urlString)
        
        let task = session.dataTask(with: url){(data, response, error) in
            guard error == nil else {return}
            guard let safeData = data else {return}
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: safeData, options: [])
                var menuTitles: [String] = []
                guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                
                for i in 0..<jsonArray.count{
                    let menu = Menu(data: jsonArray[i])
                    guard let menuCategories = menu.categories else {return}
                    
                    for j in 0..<menuCategories.count{
                        let title = menuCategories[j].title
                        menuTitles.append(title)
                    }
                }
                completed(menuTitles)
            } catch {
                print("Couldn't parse JSON")
            }
        }
        task.resume()
    }
}
