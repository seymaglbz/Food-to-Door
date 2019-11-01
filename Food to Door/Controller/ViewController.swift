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
    
    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 200
    
    private var previousLocation: CLLocation?
    private var placemark: CLPlacemark?
    private var geoCoder: CLGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose an Address"
        navigationController?.navigationBar.tintColor = .red      
        
        checkLocationServices()
    }
    
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            Alert.showUnableToRetrieveLocationAlert(on: self)
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            Alert.showUnableToRetrieveLocationAlert(on: self)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            Alert.showUnableToRetrieveLocationAlert(on: self)
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    private func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        previousLocation = getCenterLocation(for: mapView)
        if let previousLocation = previousLocation{
            reverseGeoCode(from: previousLocation)
        }
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarController = segue.destination as! UITabBarController
        if let navController = tabBarController.viewControllers?.first as? UINavigationController{
            if let exploreVC = navController.viewControllers.first as? ExploreViewController{
                exploreVC.userLocation = previousLocation
            }
        }
    }
    
    @IBAction func confirmAddress(_ sender: UIButton) {}
    
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
    
    private func reverseGeoCode(from location: CLLocation){
        geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self ](placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error{
                Alert.showUnableToRetrieveLocationAlert(on: self)
                return
            }
            
            guard let placemark = placemarks?.first else{
                Alert.showUnableToRetrieveLocationAlert(on: self)
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        
    }
}

