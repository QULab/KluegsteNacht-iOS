//
//  QULCityMapViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 18/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

func coordinateRegionForCoordinates(coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    var rect: MKMapRect = MKMapRectNull
    for coord in coords {
        let point: MKMapPoint = MKMapPointForCoordinate(coord)
        rect = MKMapRectUnion(rect, MKMapRectMake(point.x, point.y, 0, 0))
    }
    return MKCoordinateRegionForMapRect(rect)
}

class QULAnnotation: NSObject, MKAnnotation {
    let title: String
    let coordinate: CLLocationCoordinate2D
    let routeName: String
    let routeId: Int
    let stationId: Int
    
    init(stationId: Int, title: String, coordinate: CLLocationCoordinate2D, routeName: String, routeId: Int) {
        self.stationId = stationId
        self.title = title
        self.coordinate = coordinate
        self.routeName = routeName
        self.routeId = routeId
        
        super.init()
    }
    
    var subtitle: String {
        return "Route \(routeId): \(routeName)"
    }
}

class QULCityMapViewController: UIViewController  {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var didShowUserLocation: Bool?
    var selectedStationId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        zoomToCityCentre()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager?.requestWhenInUseAuthorization()
        
        showStations()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStationDetail" {
            
            let result = routeForStationId(sender!.tag)
            
            let stationViewController: StationViewController = segue.destinationViewController as! StationViewController
            stationViewController.route = result.route
            stationViewController.selectedStationIndex = result.stationIndex
            stationViewController.stations = stationViewController.route["haltestellen"] as! NSArray
        }
    }
    
    @IBAction func zoomToUserLocation(sender: AnyObject) {
        if mapView.userLocation.location != nil {
            let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.location.coordinate, 2000, 2000)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    func zoomToCityCentre() {
        let potsdam: CLLocationCoordinate2D = CLLocationCoordinate2DMake(52.38, 12.84)//52.4, 13.066667
        let buch: CLLocationCoordinate2D = CLLocationCoordinate2DMake(52.68, 13.81)//52.633611, 13.499167
        
        var southWest: CLLocationCoordinate2D = CLLocationCoordinate2D()
        southWest.latitude = min(buch.latitude, potsdam.latitude)
        southWest.longitude = min(buch.longitude, potsdam.longitude)
        
        var northEast: CLLocationCoordinate2D = CLLocationCoordinate2D()
        northEast.latitude = max(buch.latitude, potsdam.latitude)
        northEast.longitude = max(buch.longitude, potsdam.longitude)
        
        let region:MKCoordinateRegion = coordinateRegionForCoordinates([southWest,northEast])
        
        mapView.setRegion(region, animated: true)
    }
    
    func zoomToStation(stationId: Int) {
        
        for annotation in mapView.annotations {            
            if let qAnnotation = annotation as? QULAnnotation {
                if annotation.stationId == stationId {
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 2000, 2000)
                    mapView.setRegion(region, animated: true)
                    mapView.selectAnnotation(annotation as! QULAnnotation, animated: true)
                    break
                }
            }
        }
    }
    
    func showStations() {
        let routeStations = QULDataSource.sharedInstance.routesStations
        
        for routeDict in routeStations {
            let routeName: String = routeDict["name"] as! String
            let routeIdString: String = routeDict["number"] as! String
            
            if let stations = routeDict["haltestellen"] as? NSArray {
                for stationDict in stations {
                    let stationIdString: String = stationDict["id"] as! String
                    let stationName: String = stationDict["name"] as! String
                    let geo1: String? = stationDict["geo1"] as? String
                    
                    if geo1 != nil {
                        let geoCoordinates = split(geo1!) {$0 == ","}
                        
                        let annotation = QULAnnotation(stationId: (stationIdString as NSString).integerValue,
                            title: stationName,
                            coordinate: CLLocationCoordinate2DMake((geoCoordinates[0] as NSString).doubleValue, (geoCoordinates[1] as NSString).doubleValue),
                            routeName: routeName,
                            routeId: (routeIdString as NSString).integerValue)
                        
                        mapView.addAnnotation(annotation)
                    }
                    
                }
            }
        }
        
        if selectedStationId != nil {
            zoomToStation(selectedStationId!)
        }
    }
    
    func showStationDetail(sender: UIButton) {
        performSegueWithIdentifier("showStationDetail", sender: sender)
    }
    
    func routeForStationId(stationId: Int) -> (route: NSDictionary, stationIndex: Int) {
        let routeStations = QULDataSource.sharedInstance.routesStations
        
        for routeDict in routeStations {
            let routeIdString: String = routeDict["number"] as! String
            
            if let stations = routeDict["haltestellen"] as? NSArray {
                var index = 0
                for stationDict in stations {
                    let stationIdString: String = stationDict["id"] as! String
                    if stationId == (stationIdString as NSString).integerValue {
                        return (routeDict, index)
                    }
                    index++
                }
            }
        }
        
        return ([:], -1)
    }
}

extension QULCityMapViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        // nothing to do here right now
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
}

extension QULCityMapViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            
        }
    }
}

extension QULCityMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? QULAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                let button: UIButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
                button.tag = annotation.stationId
                button.addTarget(self, action: "showStationDetail:", forControlEvents: .TouchUpInside)
                view.rightCalloutAccessoryView = button
            }
            //view.image = UIImage(named: "Bus")
            return view
        }
        return nil
    }
}