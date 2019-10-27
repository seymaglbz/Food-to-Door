//
//  StoreCell.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 14.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

struct Cells{
    static let storeCell = "StoreCellIdentifier"
}

class StoreCell: UITableViewCell {
    
    var storeImage = UIImageView()
    var storeNameLabel = UILabel()
    var storeTypeLabel = UILabel()
    var deliveryTypeLabel = UILabel()
    var deliveryTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(storeImage)
        addSubview(storeNameLabel)
        addSubview(storeTypeLabel)
        addSubview(deliveryTypeLabel)
        addSubview(deliveryTimeLabel)
        
        configureLabels()
        setStoreImageConstraints()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels(){
        storeNameLabel.font = .boldSystemFont(ofSize: 17)
        storeTypeLabel.textColor = .darkGray
        deliveryTypeLabel.textColor = .darkGray
        deliveryTimeLabel.textColor = .darkGray
    }
    
    func setStoreImageConstraints(){
        storeImage.translatesAutoresizingMaskIntoConstraints = false
        storeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        storeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        storeImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        storeImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    func setLabelConstraints(){
        storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        storeTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        storeNameLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        storeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        storeNameLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        storeNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        storeTypeLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        storeTypeLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 8).isActive = true
        storeTypeLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        storeTypeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        deliveryTypeLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        deliveryTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        deliveryTypeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deliveryTypeLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        deliveryTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1).isActive = true
        deliveryTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        deliveryTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        deliveryTimeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    
    
    func set(_ store: StoreModel){
        let urlString = store.storeImage
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.storeImage.image = image
                        self.storeImage.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.storeNameLabel.text = store.storeName
            self.storeTypeLabel.text = store.storeType
            
            if store.deliveryTime == 0{
                self.deliveryTimeLabel.text = "-"
            }else{
                self.deliveryTimeLabel.text = "\(store.deliveryTime) min"
            }
            if store.deliveryFee == 0{
                self.deliveryTypeLabel.text = "Free Delivery"
            }else{
                self.deliveryTypeLabel.text = "$\(store.deliveryFee)"
            }
        }
    }
}
