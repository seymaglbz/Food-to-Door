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
    var storeManager = StoreManager()
    var storesArray = [StoreModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        storeManager.delegate = self
        
        if let latitude = userLocation?.coordinate.latitude, let longitude = userLocation?.coordinate.longitude{
            storeManager.fetchStores(latitude: latitude, longitude: longitude)
        }
        
        setupTableView()
        setupNavBar()
    }
    
    func setupNavBar(){
        navigationItem.title = "Food to Door"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-search"), style: .plain, target: self, action: #selector(searchForStores))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        //Doesn't do anything. Just put it here to complete the look. When I swipe the screen down it goes back to map anyway.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-address"), style: .plain, target: self, action: nil)
    }
    
    #warning("Write search methods")
    @objc func searchForStores(){}
    
    private func setupTableView(){
        let nib = UINib(nibName: "StoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StoreCellIdentifier")
    }
    
    func configure(cell: StoreCell, array: [StoreModel], with indexPath: IndexPath ){
        
        let urlString = array[indexPath.row].storeImage
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        cell.storeImage.image = image
                        cell.storeImage.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        DispatchQueue.main.async {
            cell.storeNameLabel.text = array[indexPath.row].storeName
            cell.storeTypeLabel.text = array[indexPath.row].storeType
            
            if array[indexPath.row].deliveryTime == 0{
                cell.deliveryTimeLabel.text = "-"
            }else{
                cell.deliveryTimeLabel.text = "\(array[indexPath.row].deliveryTime) min"
            }
            if array[indexPath.row].deliveryFee == 0{
                cell.deliveryTypeLabel.text = "Free Delivery"
            }else{
                cell.deliveryTypeLabel.text = "$\(array[indexPath.row].deliveryFee)"
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCellIdentifier", for: indexPath) as? StoreCell else {fatalError()}
        configure(cell: cell, array: self.storesArray, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let storeVC = storyboard?.instantiateViewController(identifier: "StoreVC") as? StoreViewController else {return}
        storeVC.selectedStore = storesArray[indexPath.row]
        navigationController?.pushViewController(storeVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - StoreManagerDelegate Methods
extension ExploreViewController: StoreManagerDelegate{
    func didUpdateStores(_ storeManager: StoreManager, stores: [StoreModel]) {
        storesArray = stores
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error){
        Alert.showUnableToRetrieveStoresAlert(on: self)
        print(error)
    }
    
}
