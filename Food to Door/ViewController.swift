//
//  ViewController.swift
//  Food to Door
//
//  Created by Şeyma Gılbaz on 23.09.2019.
//  Copyright © 2019 Şeyma Gılbaz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var confirmAddressButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 200
    
    var previousLocation: CLLocation?
    var placemark: CLPlacemark?
    var geoCoder: CLGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose an Address"
        
        performSelector(inBackground: #selector(checkLocationServices), with: nil)
    }
    
    @objc func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            let alert = UIAlertController(title: "To be able to use the app please enable your location services.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            let alert = UIAlertController(title: "To be able to use the app please enable your location services.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            let alert = UIAlertController(title: "To be able to use the app please enable your location services.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
        
    }
    
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
        if let previousLocation = previousLocation{
            reverseGeoCode(from: previousLocation)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    @IBAction func confirmAddress(_ sender: UIButton) {
        guard let exploreVC = storyboard?.instantiateViewController(identifier: "Explore") as? ExploreViewController else {return}
        exploreVC.usersLocation = previousLocation
        navigationController?.pushViewController(exploreVC, animated: true)
    }
    
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.mapView)
        let locationCoordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        
        if let placemark = placemark{
            annotation.title = placemark.subThoroughfare
            annotation.subtitle = placemark.thoroughfare
        }
        
        previousLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        guard let previousLocation = previousLocation else {return}
        reverseGeoCode(from: previousLocation)
    }
    
    func reverseGeoCode(from location: CLLocation){
        geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self ](placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error{
                let alert = UIAlertController(title: "Something went wrong.", message: "Please make sure your location is enabled.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let placemark = placemarks?.first else{
                let alert = UIAlertController(title: "Something went wrong.", message: "Please make sure your location is enabled.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            self.placemark = placemark
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        
    }
}

