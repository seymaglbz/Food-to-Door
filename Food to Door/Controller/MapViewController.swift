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

class MapViewController: UIViewController, MKMapViewDelegate {
    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 200
    private var previousLocation: CLLocation?
    private var placemark: CLPlacemark?
    private var geoCoder: CLGeocoder!
    var sharedMapView = SharedMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocationServices()
    }
    
    func setupUI() {
        view = sharedMapView
        sharedMapView.mapView.delegate = self
        sharedMapView.confirmAddressButton.addTarget(self, action: #selector(goToStores), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        sharedMapView.mapView.addGestureRecognizer(longPress)
    }
    
    @objc func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: sharedMapView.mapView)
        let locationCoordinate = sharedMapView.mapView.convert(location, toCoordinateFrom: sharedMapView.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        
        guard let placemark = placemark else {return}
        annotation.title = placemark.subThoroughfare
        annotation.subtitle = placemark.thoroughfare
        previousLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        sharedMapView.mapView.removeAnnotations(sharedMapView.mapView.annotations)
        sharedMapView.mapView.addAnnotation(annotation)
        
        guard let previousLocation = previousLocation else {return}
        reverseGeoCode(from: previousLocation)
    }
    
    @objc func goToStores() {
        let tabBarController = TabBarController()
        guard let navigationController = tabBarController.viewControllers?.first as? UINavigationController else {return}
        guard let exploreVC = navigationController.viewControllers.first as? ExploreViewController else {return}
        exploreVC.userLocation = previousLocation
        
        present(tabBarController, animated: true, completion: nil)
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            Alert.showUnableToRetrieveLocationAlert(on: self)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
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
    
    private func startTrackingUserLocation() {
        sharedMapView.mapView.showsUserLocation = true
        centerViewOnUserLocation()
        previousLocation = getCenterLocation(for: sharedMapView.mapView)
        guard let previousLocation = previousLocation else {return}
        
        reverseGeoCode(from: previousLocation)
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else {return}
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        sharedMapView.mapView.setRegion(region, animated: true)
    }
    
    private func reverseGeoCode(from location: CLLocation) {
        geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self ](placemarks, error) in
            guard let self = self else {return}
            
            guard error == nil else {
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
                self.sharedMapView.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

