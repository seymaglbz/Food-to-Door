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
    private var searchBar = UISearchBar()
    
    var dataManager = DataManager()
    lazy var dataSourceProvider = DataSourceProvider(dataManager: dataManager)
    lazy var searchBarManager = SearchBar(dataManager: dataManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSourceProvider
        tableView.delegate = dataSourceProvider
        dataSourceProvider.delegate = self
        searchBarManager.delegate = self
        
        setupNavBar()
        dataManager.loadFavorites()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataManager.loadFavorites()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        searchBar.delegate = searchBarManager
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.titleView = searchBar
    }
}

//MARK: - DataSourceProviderDelegate, SearchBarDelegate
extension FavoritesViewController: DataSourceProviderDelegate, SearchBarDelegate{
    
    func selectedCell(row: Int) {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        guard let storeVC = storyboard.instantiateViewController(identifier: "StoreVC") as? StoreViewController else {return}
        
        if dataManager.isSearching{
            storeVC.selectedStore = dataManager.searchedStores[row]
        }else{
            storeVC.selectedStore = dataManager.stores[row]
        }
        navigationController?.pushViewController(storeVC, animated: true)
    }
    
    func searchCancelButtonClicked() {
        navigationItem.titleView = nil
        setupNavBar()
        dataManager.isSearching = false
        searchBar.searchTextField.text = ""
        tableView.reloadData()
    }
    
    func setSearchedStores() {
        tableView.reloadData()
    }
    
}
