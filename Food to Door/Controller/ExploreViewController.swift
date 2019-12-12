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
    private var searchBar = UISearchBar()
    private var dataManager = DataManager()
    lazy var dataSourceProvider = DataSourceProvider(dataManager: dataManager)
    lazy var searchBarManager = SearchBar(dataManager: dataManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        tableView.dataSource = dataSourceProvider
        tableView.delegate = dataSourceProvider
        dataSourceProvider.delegate = self
        searchBarManager.delegate = self
        
        loadStores()
        setupNavBar()
    }
    
    func loadStores() {
        guard let latitude = userLocation?.coordinate.latitude, let longitude = userLocation?.coordinate.longitude else {return}
        NetworkManager.shared.fetchStores(latitude: latitude, longitude: longitude){ stores in
            guard let stores = stores else {
                Alert.showUnableToRetrieveStoresAlert(on: self)
                return
            }
            self.dataManager.stores = stores
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupNavBar() {
        navigationItem.title = "Food to Door"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-search"), style: .plain, target: self, action: #selector(searchForStores))
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-address"), style: .plain, target: self, action: nil)
    }
    
    @objc func searchForStores() {
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

//MARK: - UITabBarControllerDelegate
extension ExploreViewController: UITabBarControllerDelegate {
    //When explore button on the tabbar tapped, always goes back to ExploreViewController
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let navController = tabBarController.viewControllers?.first as! UINavigationController
        navController.popToRootViewController(animated: true)
    }
}

//MARK: - DataSourceProviderDelegate, SearchBarDelegate
extension ExploreViewController: DataSourceProviderDelegate, SearchBarDelegate {
    
    func selectedCell(row: Int) {        
        guard let storeVC = storyboard?.instantiateViewController(identifier: "StoreVC") as? StoreViewController else {return}
      
        storeVC.selectedStore = dataManager.isSearching ? dataManager.searchedStores[row] : dataManager.stores[row]
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

