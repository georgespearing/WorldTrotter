//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by user203264 on 11/27/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    
    var mapView: MKMapView!
    
    override func loadView(){
        // create a map view
        mapView = MKMapView()
        
        // set it as *the* view of this view controller
        view = mapView
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view")
    }
    
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
    
    @objc func poiDisplay(_ poiSwitch: UISwitch) {
        if poiSwitch.isOn{
            mapView.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [] )
            
        }
        if !poiSwitch.isOn{
            mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [] )
            
        }
        
    }
    
}
