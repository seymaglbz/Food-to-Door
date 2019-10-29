//
//  FavoritesViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 14.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var favoriteStores = [StoreModel]()
        var searchBar = UISearchBar()
        var searchedStoresNames = [String]()
        var searchedStores = [StoreModel]()
        var isSearching = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            setupTableView()
            setupNavBar()
            loadFavorites()
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tableView.reloadData()
        }
        
        private func setupTableView(){
            tableView.register(StoreCell.self, forCellReuseIdentifier: Cells.storeCell)
        }
        
        func setupNavBar(){
            navigationItem.title = "Food to Door"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-search"), style: .plain, target: self, action: #selector(searchForStores))
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-address"), style: .plain, target: self, action: nil)
        }
        
        func saveFavorites(_ storesArray : [StoreModel]){
            let defaults = UserDefaults.standard
            let jsonEncoder = JSONEncoder()
            if let savedData = try? jsonEncoder.encode(storesArray){
                defaults.set(savedData, forKey: "favoriteStoresArray")
            }else{
                DispatchQueue.main.async {
                    Alert.showUnableToSaveToFavoritesAlert(on: self)
                }
            }
        }
        
        func loadFavorites(){
            let defaults = UserDefaults.standard
            if let favoriteStores = defaults.object(forKey: "favoriteStoresArray") as? Data{
                let jsonDecoder = JSONDecoder()
                do{
                    self.favoriteStores = try jsonDecoder.decode([StoreModel].self, from: favoriteStores)
                }catch{
                    DispatchQueue.main.async {
                        Alert.showUnableToLoadFavoritesAlert(on: self)
                    }
                }
            }
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
    extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSearching{
                return searchedStores.count
            }else{
                return favoriteStores.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.storeCell) as? StoreCell else {fatalError()}
            if isSearching{
                let searchedStore = searchedStores[indexPath.row]
                cell.set(searchedStore)
            }else{
                let store = favoriteStores[indexPath.row]
                cell.set(store)
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                self.favoriteStores.remove(at: indexPath.row)
                saveFavorites(favoriteStores)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Explore", bundle: nil)
            guard let storeVC = storyboard.instantiateViewController(identifier: "StoreVC") as? StoreViewController else {return}
            if isSearching{
                storeVC.selectedStore = searchedStores[indexPath.row]
            }else{
                storeVC.selectedStore = favoriteStores[indexPath.row]
            }
            navigationController?.pushViewController(storeVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }

    //MARK: - UISearchBarDelegate
    extension FavoritesViewController: UISearchBarDelegate{
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            navigationItem.titleView = nil
            setupNavBar()
            isSearching = false
            searchBar.searchTextField.text = ""
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let storeNames = favoriteStores.map{$0.storeName}
            searchedStoresNames = storeNames.filter({$0.prefix(searchText.count) == searchText})
            searchedStores.removeAll()
            
            for i in favoriteStores{
                if searchedStoresNames.contains(i.storeName){
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
