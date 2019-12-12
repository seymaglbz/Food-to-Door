//
//  SearchBar.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 21.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

protocol SearchBarDelegate {
    func searchCancelButtonClicked()
    func setSearchedStores()
}

class SearchBar: NSObject, UISearchBarDelegate {
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
        let storeNames = dataManager.stores.map{$0.business.name}
        dataManager.searchedStoresNames = storeNames.filter({$0.prefix(searchText.count) == searchText})
        dataManager.searchedStores.removeAll()
        
        for store in dataManager.stores where dataManager.searchedStoresNames.contains(store.business.name) {
            dataManager.searchedStores.append(store)
        }
        
        dataManager.isSearching = true
        delegate?.setSearchedStores()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
    }
}

