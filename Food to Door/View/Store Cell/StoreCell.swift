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
    
    private var storeImage = UIImageView()
    private var storeNameLabel = UILabel()
    private var storeTypeLabel = UILabel()
    private var deliveryTypeLabel = UILabel()
    private var deliveryTimeLabel = UILabel()
    
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
    
    private func configureLabels(){
        storeNameLabel.font = .boldSystemFont(ofSize: 17)
        storeTypeLabel.font = .systemFont(ofSize: 16)
        deliveryTypeLabel.font = .systemFont(ofSize: 16)
        storeTypeLabel.textColor = .darkGray
        deliveryTypeLabel.textColor = .darkGray
        deliveryTimeLabel.textColor = .darkGray
        
    }
    
    private func setStoreImageConstraints(){
        storeImage.translatesAutoresizingMaskIntoConstraints = false
        storeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        storeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        storeImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        storeImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func setLabelConstraints(){
        storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        storeTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        deliveryTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        storeNameLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        storeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        storeNameLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        storeNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        storeTypeLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        storeTypeLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 5).isActive = true
        storeTypeLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        storeTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        deliveryTypeLabel.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10).isActive = true
        deliveryTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        deliveryTypeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deliveryTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        deliveryTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1).isActive = true
        deliveryTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        deliveryTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        deliveryTimeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func set(_ store: Store){
        
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
            self.storeNameLabel.text = store.storeName.name
            self.storeTypeLabel.text = store.storeType
            if let deliveryTime = store.deliveryTime, let deliveryFee = store.deliveryFee{
                if deliveryTime == 0{
                    self.deliveryTimeLabel.text = "-"
                }else{
                    self.deliveryTimeLabel.text = "\(deliveryTime) min"
                }
                if deliveryFee == 0{
                    self.deliveryTypeLabel.text = "Free Delivery"
                }else{
                    self.deliveryTypeLabel.text = "$\(deliveryFee)"
                }
            }
            
            
            
        }
    }
}
