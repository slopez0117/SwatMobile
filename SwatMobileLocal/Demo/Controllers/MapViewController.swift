//
//  MapViewController.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 8/31/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        }
        else{
            mapView.mapType = .satellite
        }
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swarthmore college location: LAT: 39.903014 LNG: -75.354838
        let swat = CLLocation(latitude: 39.903014, longitude: -75.354838)
        let regionRadius: CLLocationDistance = 1500.0
        let region = MKCoordinateRegion(center: swat.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.delegate = self
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
    }


}

extension MapViewController: MKMapViewDelegate{
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("rendering...")
    }
}
