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
    
    var storesArray = [Store]()
    private var searchBar = UISearchBar()
    
    private var searchedStoresNames = [String]()
    private var searchedStores = [Store]()
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let latitude = userLocation?.coordinate.latitude, let longitude = userLocation?.coordinate.longitude{
            NetworkManager.shared.fetchStores(latitude: latitude, longitude: longitude){ stores in
                guard let stores = stores else {
                    Alert.showUnableToRetrieveStoresAlert(on: self)
                    return
                }
                self.storesArray = stores
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        setupTableView()
        setupNavBar()
    }
    
    private func setupTableView(){
        tableView.register(StoreCell.self, forCellReuseIdentifier: Cells.storeCell)
    }
    
    private func setupNavBar(){
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
        searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.titleView = searchBar
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
        
        if isSearching{
            storeVC.selectedStore = searchedStores[indexPath.row]
        }else{
            storeVC.selectedStore = storesArray[indexPath.row]
        }
        
        navigationController?.pushViewController(storeVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupNavBar()
        isSearching = false
        searchBar.searchTextField.text = ""
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let storeNames = storesArray.map{$0.storeName.name}
        searchedStoresNames = storeNames.filter({$0.prefix(searchText.count) == searchText})
        searchedStores.removeAll()
        
        for i in storesArray{
            if searchedStoresNames.contains(i.storeName.name){
                searchedStores.append(i)
            }
        }
        isSearching = true
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.searchTextField.endEditing(true)
    }
}
