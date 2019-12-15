//
//  SharedStoreView.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 14.12.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class SharedStoreView: UIView {
    
    let storeImage = UIImageView()
    let deliveryLabel = UILabel()
    let addToFavoritesButton = FavoriteButton()
    let menuLabel = UILabel()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        backgroundColor = .systemBackground
        
        setupImageView()
        setupDeliveryLabel()
        setupAddToFavoritesButton()
        setupMenuLabel()
        setupTableView()
    }
    
    func setupImageView() {
        addSubview(storeImage)
        storeImage.translatesAutoresizingMaskIntoConstraints = false        
        storeImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storeImage.topAnchor.constraint(equalTo: topAnchor, constant: 107).isActive = true
        storeImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        storeImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        storeImage.contentMode = .scaleAspectFit
    }
    
    func setupDeliveryLabel() {
        addSubview(deliveryLabel)
        deliveryLabel.textAlignment = .center
        deliveryLabel.textColor = .darkGray
        deliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryLabel.heightAnchor.constraint(equalToConstant: 37).isActive = true
        deliveryLabel.widthAnchor.constraint(equalToConstant: 374).isActive = true
        deliveryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        deliveryLabel.topAnchor.constraint(equalTo: storeImage.bottomAnchor, constant: 8).isActive = true
    }
    
    func setupAddToFavoritesButton() {
        addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
        addToFavoritesButton.widthAnchor.constraint(equalToConstant: 251).isActive = true
        addToFavoritesButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addToFavoritesButton.topAnchor.constraint(equalTo: deliveryLabel.bottomAnchor, constant: 23).isActive = true
    }
    
    func setupMenuLabel() {
        addSubview(menuLabel)
        menuLabel.text = "     Menu"
        menuLabel.textColor = .darkGray
        menuLabel.font = .systemFont(ofSize: 15)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        menuLabel.topAnchor.constraint(equalTo: addToFavoritesButton.bottomAnchor, constant: 31).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        menuLabel.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: menuLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
