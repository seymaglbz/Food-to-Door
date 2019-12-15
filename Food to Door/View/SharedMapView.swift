//
//  SharedMapView.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 15.12.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit
import MapKit

class SharedMapView: UIView {
    let mapView = MKMapView()
    let addressLabel = UILabel()
    let confirmAddressButton = UIButton()
    let navBar = UINavigationBar()
   
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
        configureNavBar()
        configureMapView()
        configureAddressLabel()
        configureConfirmAddressButton()
    }
    
    func configureNavBar() {
        addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: topAnchor, constant: 44).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let navItem = UINavigationItem(title: "Choose an Address")
        navBar.setItems([navItem], animated: true)
    }
    
    func configureMapView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func configureAddressLabel() {
        addSubview(addressLabel)
        addressLabel.textColor = .darkGray
        addressLabel.textAlignment = .center
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureConfirmAddressButton() {
        addSubview(confirmAddressButton)
        confirmAddressButton.backgroundColor = .red
        confirmAddressButton.setTitleColor(.white, for: .normal)
        confirmAddressButton.setTitle("Confirm Address", for: .normal)
        confirmAddressButton.translatesAutoresizingMaskIntoConstraints = false
        confirmAddressButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor).isActive = true
        confirmAddressButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        confirmAddressButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        confirmAddressButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        confirmAddressButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
