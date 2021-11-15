//
//  ViewController.swift
//  Safe Cargo Delivery
//
//  Created by Phil Mui on 11/14/21.
//

import UIKit
import MapKit
import CoreLocation
import LogStore

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // var locationProvider: LocationProvider?
    var locationManager = CLLocationManager()
    var coordinates: [CLLocationCoordinate2D] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    func setup() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //Map view settings
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        
        // adding co-ordinates for poly line (added static, we can make it dyanamic)
        let coords1 = CLLocationCoordinate2D(latitude: 37.5131625, longitude: -122.2922321) // chase
        let coords2 = CLLocationCoordinate2D(latitude: 37.5107689, longitude: -122.2930516) // lunardi
        let coords3 = CLLocationCoordinate2D(latitude: 37.508829, longitude: -122.293293)  // library
        let coords4 = CLLocationCoordinate2D(latitude: 37.5065247, longitude: -122.2903888) // carlmont
        let coords5 = CLLocationCoordinate2D(latitude: 37.5089317, longitude: -122.2861046) // tierra linda
        coordinates = [coords1,coords2,coords3,coords4,coords5]
        determineCurrentLocation()
    }
    
    func determineCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // adding map region
        let userLocation:CLLocation = locations[0] as CLLocation
        let travelLine = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        // adding annotation aat particular point
        for each in 0..<coordinates.count{
            let anno = MKPointAnnotation()
            anno.coordinate = coordinates[each]
            mapView.addAnnotation(anno as MKAnnotation)
        }
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(travelLine)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        var testlineRenderer: MKPolylineRenderer?
        if let polyline = overlay as? MKPolyline {
            testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer!.strokeColor = .blue
            testlineRenderer!.lineWidth = 2.0
        }
        return testlineRenderer!
    }
}

