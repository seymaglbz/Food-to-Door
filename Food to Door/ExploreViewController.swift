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

    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    
    var usersLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let usersLocation = usersLocation{
            longitudeLabel.text = "Longitude: \(usersLocation.coordinate.longitude)"
            latitudeLabel.text = "Latitude: \(usersLocation.coordinate.latitude)"
            
        }
        
    }
    

 

}
