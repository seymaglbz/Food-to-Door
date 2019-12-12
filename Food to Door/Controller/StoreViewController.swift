//
//  StoreViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet var storeImage: UIImageView!
    @IBOutlet var deliveryLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: FavoriteButton!
    @IBOutlet var tableView: UITableView!
    
    private var menuArray: [String] = []
    var selectedStore: Store?
    var dataManager = DataManager()
    let secondVC = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navController = tabBarController?.viewControllers?[secondVC] as? UINavigationController else {return}
        guard let favoriteVC = navController.viewControllers.first as? FavoritesViewController else {
            Alert.showUnableToLoadFavoritesAlert(on: self)
            return
        }
        favoriteVC.dataManager.loadFavorites()
        
        setupUI()
    }
    
    private func setupUI() {
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
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.navigationItem.title = selectedStore.business.name
            self.storeImage.image = image
            self.deliveryLabel.text = selectedStore.deliveryFee == 0 ? "Free Delivery in \(deliveryTime) min" : "Delivery for $\(deliveryFee) in \(deliveryTime) min"
            
            if deliveryTime == 0{
                self.deliveryLabel.text = "Free Delivery"
            }
            
            self.addToFavoritesButton.configure(for: tabBarController, store: selectedStore)
        }
    }
    
    @IBAction func addToFavoritesTapped(_ sender: FavoriteButton) {
        addToFavoritesButton.favoritedUISetup()
 
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
