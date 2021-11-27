//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by user203264 on 11/27/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    var mapView: MKMapView!
    
    // location variables
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    
    
    override func loadView(){
        // create a map view
        mapView = MKMapView()
        
        // set it as *the* view of this view controller
        view = mapView
        
        // MARK: - Segmented Map Views
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
//        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // MARK: - POI Label and Switch
        
        // Adding the label
        let pointsLabel = UILabel()
        pointsLabel.text = "Points of Interest"
        pointsLabel.textColor = UIColor.red
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointsLabel)
        let labelTopConstraint = pointsLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let labelLeadingConstraint = pointsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        
        labelTopConstraint.isActive = true
        labelLeadingConstraint.isActive = true
        
        // Adding the switch
        let poiSwitch = UISwitch()
        poiSwitch.isOn = true
        poiSwitch.addTarget(self, action: #selector(poiDisplay(_:)), for: .valueChanged)
        
        poiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(poiSwitch)
        let switchTopConstraint = poiSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let switchLeadingConstraint = poiSwitch.leadingAnchor.constraint(equalTo: pointsLabel.trailingAnchor, constant: 8)
        
        switchTopConstraint.isActive = true
        switchLeadingConstraint.isActive = true
        
        // Adding the Button
        let fmButton = UIButton()
        fmButton.setTitle("Find Me", for: .normal)
        fmButton.setTitleColor(UIColor.black, for: .normal)
        fmButton.backgroundColor = UIColor.white
        fmButton.layer.borderWidth = 1
        fmButton.layer.cornerRadius = 2
        
        fmButton.addTarget(self, action: #selector(findActive(_:)), for: .touchDown)
        
        fmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fmButton)
        
        let fmButtonTopConstraint = fmButton.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant:8)
        let fmButtonLeadingConstraint = fmButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        let fmButtonWidthConstraint = fmButton.widthAnchor.constraint(
        equalToConstant: fmButton.titleLabel!.intrinsicContentSize.width + 2.0 * 3)
        
        fmButtonTopConstraint.isActive = true
        fmButtonLeadingConstraint.isActive = true
        fmButtonWidthConstraint.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view")
        
        // initializing the location manager when the view is loaded
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    // updating the current location using the GPS locaiton value
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last as CLLocation?
    }
    
   // If the segmented controller changes, change the mapView to the coresponding view
    @objc func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    // When the POI Switch changes state, remove or add the points of interest filter
    @objc func poiDisplay(_ poiSwitch: UISwitch) {
        if poiSwitch.isOn{
            mapView.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [] )
            
        }
        if !poiSwitch.isOn{
            mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [] )
            
        }
        
    }
    
    // When "Find Me" Button is pressed, update location, map view, and add annotation
    @objc func findActive(_ fmButton: UIButton){
        print("Find Me")
        
        // Hard Code value to Burlington
//        let btvCoord = CLLocationCoordinate2D(latitude: 44.4788381, longitude: -73.1974602)
//        var fmSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
//        var fmRegion = MKCoordinateRegion(center: btvCoord, latitudinalMeters: 100, longitudinalMeters: 100)
//        mapView.setRegion(fmRegion, animated: true)
//        var currMarker = MKPointAnnotation()
//        currMarker.coordinate = btvCoord
//        mapView.addAnnotation(currMarker)
        
        // get locaiton from GPS (or the "Location" in the Simulator)
        let center = CLLocationCoordinate2D(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
        
        // remove old annotations and add the current location
        var currMarker = MKPointAnnotation()
        currMarker.coordinate = center
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(currMarker)
        
        
    }
    
    
    
}
