//
//  ExploreViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 23.09.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit
import CoreLocation

class ExploreViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var userLocation: CLLocation?
    var storeManager = StoreManager()
    var storesArray = [StoreModel]()
    var searchBar = UISearchBar()
    
    var searchedStoresNames = [String]()
    var searchedStores = [StoreModel]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        storeManager.delegate = self
        
        if let latitude = userLocation?.coordinate.latitude, let longitude = userLocation?.coordinate.longitude{
            storeManager.fetchStores(latitude: latitude, longitude: longitude)
        }
        
        setupTableView()
        setupNavBar()
    }
    
    func setupNavBar(){
        navigationItem.title = "Food to Door"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-search"), style: .plain, target: self, action: #selector(searchForStores))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-address"), style: .plain, target: self, action: nil)
    }
    
    @objc func searchForStores(){
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView(){
        tableView.register(StoreCell.self, forCellReuseIdentifier: Cells.storeCell)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchedStores.count
        }else{
            return storesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.storeCell) as? StoreCell else {fatalError()}
        if isSearching{
            let searchedStore = searchedStores[indexPath.row]
            cell.set(searchedStore)
        }else{
            let store = storesArray[indexPath.row]
            cell.set(store)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let storeVC = storyboard?.instantiateViewController(identifier: "StoreVC") as? StoreViewController else {return}
        storeVC.selectedStore = storesArray[indexPath.row]
        navigationController?.pushViewController(storeVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - StoreManagerDelegate Methods
extension ExploreViewController: StoreManagerDelegate{
    func didUpdateStores(_ storeManager: StoreManager, stores: [StoreModel]) {
        storesArray = stores
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error){
        Alert.showUnableToRetrieveStoresAlert(on: self)
        print(error)
    }
    
}

//MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupNavBar()
        isSearching = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let storeNames = storesArray.map{$0.storeName}
        searchedStoresNames = storeNames.filter({$0.prefix(searchText.count) == searchText})
        
        #warning("Adds a store more than once")
        for i in storesArray{
            if searchedStoresNames.contains(i.storeName){
                searchedStores.append(i)
            }
        }
        print(searchedStoresNames)
        isSearching = true
        tableView.reloadData()
    }
}
