//
//  Alert.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 4.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil)}
    }
    
    static func showUnableToRetrieveLocationAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "To be able to use the app please enable your location services.", message: "")
    }
    
    static func showUnableToRetrieveStoresAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Stores couldn't be loaded", message: "Please check your internet connection")
    }
    
    static func showUnableToRetrieveMenusAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Menus couldn't be loaded", message: "Please check your internet connection")
    }
    
    static func showUnableToSaveToFavoritesAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Failed to save the store to your favorite stores list", message: "Please try again later")
    }
    
    static func showUnableToLoadFavoritesAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Failed to load your favorite stores", message: "Please try again later")
    }
}

