//
//  DataSourceProvider.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 19.11.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit

protocol DataSourceProviderDelegate: class {
    func selectedCell(row: Int)
}

class DataSourceProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let dataManager: DataManager
    var delegate: DataSourceProviderDelegate?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.storesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(StoreCell.self, forCellReuseIdentifier: Cells.storeCell)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.storeCell) as? StoreCell else {fatalError()}
        let store = dataManager.store(at: indexPath.row)
        cell.set(store)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            dataManager.deleteStore(at: indexPath.row)
            dataManager.saveFavorites(dataManager.stores)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


