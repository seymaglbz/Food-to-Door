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
    
    var menuArray = [MenuModel]()
    var menuManager = MenuManager()
    var selectedStore: StoreModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuManager.delegate = self
        loadFavorites()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
        if let tabBarController = self.tabBarController, let selectedStore = selectedStore{
            self.addToFavoritesButton.configureFavoritesButton(tabBarController: tabBarController, store: selectedStore)
        }
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
        if let navController = tabBarController?.viewControllers?[1] as? UINavigationController{
            if let favoriteVC = navController.viewControllers.first as? FavoritesViewController{
                DispatchQueue.global(qos: .background).async {
                    let defaults = UserDefaults.standard
                    if let favoriteStores = defaults.object(forKey: "favoriteStoresArray") as? Data{
                        let jsonDecoder = JSONDecoder()
                        do{
                            favoriteVC.favoriteStores = try jsonDecoder.decode([StoreModel].self, from: favoriteStores)
                        }catch{
                            DispatchQueue.main.async {
                                Alert.showUnableToLoadFavoritesAlert(on: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setupUI(){
        if let selectedStore = selectedStore{
            DispatchQueue.global(qos: .background).async {
                self.menuManager.fetchMenu(with: selectedStore.storeID)
            }
            let urlString = selectedStore.storeImage
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data){
                            self.storeImage.image = image
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.navigationItem.title = selectedStore.storeName
                if selectedStore.deliveryFee == 0{
                    self.deliveryLabel.text = "Free Delivery in \(selectedStore.deliveryTime) min"
                }else{
                    self.deliveryLabel.text = "Delivery for $\(selectedStore.deliveryFee) in \(selectedStore.deliveryTime) min"
                }
                if let tabBarController = self.tabBarController{
                    self.addToFavoritesButton.configureFavoritesButton(tabBarController: tabBarController, store: selectedStore)
                }
            }
        }
    }
    
    @IBAction func addToFavoritesTapped(_ sender: FavoriteButton) {
        addToFavoritesButton.favoritedUISetup()
        if let navController = tabBarController?.viewControllers?[1] as? UINavigationController{
            if let favoriteVC = navController.viewControllers.first as? FavoritesViewController{
                if let selectedStore = selectedStore{
                    for i in favoriteVC.favoriteStores{
                        if i.storeID == selectedStore.storeID{
                            return
                        }
                    }
                    favoriteVC.favoriteStores.append(selectedStore)
                    saveFavorites(favoriteVC.favoriteStores)
                }
            }
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension StoreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row].title
        return cell
    }
}

//MARK: - MenuManagerDelegate
extension StoreViewController: MenuManagerDelegate{
    func didUpdateMenu(_ menuManager: MenuManager, menu: [MenuModel]) {
        menuArray = menu
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        Alert.showUnableToRetrieveMenusAlert(on: self)
        print(error)
    }
    
}
