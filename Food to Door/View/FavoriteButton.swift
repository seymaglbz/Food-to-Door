//
//  FavoriteButton.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 27.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    
    var dataManager = DataManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func favoritedUISetup() {
        backgroundColor = .red
        setTitle(" Favorited", for: .normal)
        setTitleColor(.white, for: .normal)
        setImage(UIImage(named: "star-white"), for: .normal)
    }
    
    func unfavoritedUISetup() {
        setTitle("Add to Favorites", for: .normal)
        setTitleColor(.red, for: .normal)
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 1
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
    func configure(for tabBarController: UITabBarController, store: Store) {
        let secondVC = 1
        guard let navController = tabBarController.viewControllers?[secondVC] as? UINavigationController else {return}
        guard let favoriteVC = navController.viewControllers.first as? FavoritesViewController else {return}
        let storeNames = favoriteVC.dataManager.stores.map{$0.business.name}
        
        DispatchQueue.main.async {
            storeNames.contains(store.business.name) ?  self.favoritedUISetup() : self.unfavoritedUISetup()
        }
    }    
}
