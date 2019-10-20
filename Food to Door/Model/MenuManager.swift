//
//  MenuManager.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation

protocol MenuManagerDelegate{
    func didUpdateMenu(_ menuManager: MenuManager, menu: [MenuModel])
    func didFailWithError(error: Error)
}

struct MenuManager{
    
    let menuURL = "https://api.doordash.com/v2/restaurant/"
    var delegate: MenuManagerDelegate?
    
    func fetchMenu(with id: Int){
        let urlString = "\(menuURL)\(id)/menu/"
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
                    if let menus = self.parseJSON(safeData){
                        self.delegate?.didUpdateMenu(self, menu: menus)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON( _ menuData: Data) -> [MenuModel]? {
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
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
