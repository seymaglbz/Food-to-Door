//
//  StoreViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    var sharedStoreView = SharedStoreView()
    private var menuArray: [String] = []
    var selectedStore: Store?
    var dataManager = DataManager()
    let secondVC = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view = sharedStoreView
        loadFavoriteStores()
        
        sharedStoreView.tableView.delegate = self
        sharedStoreView.tableView.dataSource = self
        
        sharedStoreView.addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesButtonTapped), for: .touchUpInside)
        
        guard let selectedStore = selectedStore else {return}
        let urlString = selectedStore.image
        guard let url = URL(string: urlString) else {return}
        guard let data = try? Data(contentsOf: url) else {return}
        guard let image = UIImage(data: data) else {return}
        guard let deliveryTime = selectedStore.deliveryTime, let deliveryFee = selectedStore.deliveryFee else {return}
        guard let tabBarController = self.tabBarController else {return}
        
        NetworkManager.shared.fetchMenu(with: selectedStore.id) { (menus) in
            guard let menus = menus else {
                Alert.showUnableToRetrieveMenusAlert(on: self)
                return
            }
            self.menuArray = menus
            DispatchQueue.main.async {
                self.sharedStoreView.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.navigationItem.title = selectedStore.business.name
            self.sharedStoreView.storeImage.image = image
            self.sharedStoreView.deliveryLabel.text = selectedStore.deliveryFee == 0 ? "Free Delivery in \(deliveryTime) min" : "Delivery for $\(deliveryFee) in \(deliveryTime) min"
            
            if deliveryTime == 0{
                self.sharedStoreView.deliveryLabel.text = "Free Delivery"
            }
            
            self.sharedStoreView.addToFavoritesButton.configure(for: tabBarController, store: selectedStore)
        }
    }
    
    func loadFavoriteStores() {
        guard let navController = tabBarController?.viewControllers?[secondVC] as? UINavigationController else {return}
        guard let favoriteVC = navController.viewControllers.first as? FavoritesViewController else {
            Alert.showUnableToLoadFavoritesAlert(on: self)
            return
        }
        favoriteVC.dataManager.loadFavorites()
    }
    
    @objc func addToFavoritesButtonTapped() {
        sharedStoreView.addToFavoritesButton.favoritedUISetup()
        
        guard let navController = tabBarController?.viewControllers?[secondVC] as? UINavigationController else {return}
        guard let favoriteVC = navController.viewControllers.first as? FavoritesViewController else {return}
        guard let selectedStore = selectedStore else {
            DispatchQueue.main.async {
                Alert.showUnableToSaveToFavoritesAlert(on: self)
            }
            return}
        for store in favoriteVC.dataManager.stores where store.id == selectedStore.id {return}
        
        favoriteVC.dataManager.stores.append(selectedStore)
        dataManager.saveFavorites(favoriteVC.dataManager.stores)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
}
