//
//  FavoritesViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 14.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        configureNavigationBar()
        
    }
    
    func configureNavigationBar(){
        let navItem = UINavigationItem(title: "Food to Door")
        let searchButton = UIBarButtonItem(image: UIImage(named: "nav-search"), style: .plain, target: self, action: #selector(searchForStores))
        let addressButton = UIBarButtonItem(image: UIImage(named: "nav-address"), style: .plain, target: self, action: nil)
        navItem.rightBarButtonItem = searchButton
        navItem.leftBarButtonItem = addressButton
        navBar.setItems([navItem], animated: true)
    }
    
    #warning("Write search methods")
    @objc func searchForStores(){}
    
    private func setupTableView(){
        let nib = UINib(nibName: "StoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StoreCellIdentifier")
    }    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCellIdentifier", for: indexPath) as? StoreCell else {fatalError()}
        return cell
    }
}

