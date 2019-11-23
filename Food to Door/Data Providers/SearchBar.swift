//
//  SearchBar.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 21.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

protocol  SearchBarDelegate {
    func searchCancelButtonClicked()
    func setSearchedStores()
}

class SearchBar: NSObject, UISearchBarDelegate{
    
    var delegate: SearchBarDelegate?
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchCancelButtonClicked()
        dataManager.isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let storeNames = dataManager.stores.map{$0.storeName.name}
        dataManager.searchedStoresNames = storeNames.filter({$0.prefix(searchText.count) == searchText})
        dataManager.searchedStores.removeAll()
        
        for i in dataManager.stores{
            if dataManager.searchedStoresNames.contains(i.storeName.name){
                dataManager.searchedStores.append(i)
            }
        }
        
        dataManager.isSearching = true
        delegate?.setSearchedStores()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
    }

}

