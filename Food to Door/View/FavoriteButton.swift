//
//  FavoriteButton.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 27.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton{
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func favoritedUISetup(){
        backgroundColor = .red
        tintColor = .white
        setTitle(" Favorited", for: .normal)
        setImage(UIImage(named: "star-white"), for: .normal)
    }
    
    func unfavoritedUISetup(){
        layer.cornerRadius = 1
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
    func configureFavoritesButton(tabBarController: UITabBarController, store: Store){
        if let navController = tabBarController.viewControllers?[1] as? UINavigationController{
            if let favoriteVC = navController.viewControllers.first as? FavoritesViewController{
                let storeNames = favoriteVC.favoriteStores.map{$0.storeName.name}
                if storeNames.contains(store.storeName.name){
                    DispatchQueue.main.async {
                        self.favoritedUISetup()
                    }
                    return
                }else{
                    DispatchQueue.main.async {
                        self.unfavoritedUISetup()
                    }
                }
            }
        }
    }
    
}
