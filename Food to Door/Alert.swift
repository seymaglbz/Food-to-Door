//
//  Alert.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 4.10.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    
    static func showBasicAlert(on vc: UIViewController){
        let alert = UIAlertController(title:"To be able to use the app please enable your location services.", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }    
  
}
