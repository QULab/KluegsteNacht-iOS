//
//  QULMapViewController.swift
//  Lange N8 Karten
//
//  Created by TU on 27/04/15.
//  Copyright (c) 2015 TU Berlin. All rights reserved.
//

import Foundation
import MapKit


class QULMapViewController: NSObject, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    private var routeCoordinates: Array<CLLocationCoordinate2D>?
    var selectedCoordinate: CLLocationCoordinate2D?
    var annotations: [QULAnnotation] = [QULAnnotation]()
    let invalidAnnotation: QULAnnotation = QULAnnotation(stationId: -1, title: "", coordinate: CLLocationCoordinate2DMake(-1, -1), routeName: "", routeId: -1)
    var routeColor: UIColor = UIColor.blueColor()
    
    override init() {
        super.init()
        
    }
    
    init(theMap: MKMapView) {
        super.init()
        self.map = theMap
        self.map.delegate = self;
    }
    

    
    func setStations(stations: Array<NSDictionary>, routeDict: NSDictionary) {
        
        let routeName: String = routeDict["name"] as! String
        let routeIdString: String = routeDict["number"] as! String
        var coordinates = [CLLocationCoordinate2D]()
        for stationDict in stations {
            let stationIdString: String = stationDict["id"] as! String
            let stationName: String = stationDict["name"] as! String
            let geo1: String? = stationDict["geo1"] as? String
            
            if geo1 != nil {
                let geoCoordinates = split(geo1!) {$0 == ","}
                let coordinate = CLLocationCoordinate2DMake((geoCoordinates[0] as NSString).doubleValue, (geoCoordinates[1] as NSString).doubleValue)
                coordinates.append(coordinate)
                let annotation = QULAnnotation(stationId: (stationIdString as NSString).integerValue,
                    title: stationName,
                    coordinate: coordinate,
                    routeName: routeName,
                    routeId: (routeIdString as NSString).integerValue)
                
                self.routeColor = StationViewController.colorForRoute(routeIdString)
                self.map.addAnnotation(annotation)
                annotations.append(annotation)
            } else {
                annotations.append(invalidAnnotation)
            }
        }
        self.plotRoute(coordinates)
    }
    
    func plotRoute(coordinates: Array<CLLocationCoordinate2D>) {
        self.routeCoordinates = coordinates;
        map.showAnnotations(map.annotations, animated: true)
        
        /*
        if let existingCoordinates = self.routeCoordinates {
            if  existingCoordinates != coordinates {
                self.map.removeOverlays(self.map.overlays)
                self.map.removeAnnotation(self.map.annotations)
            }
        }
        */
        for var i = 0; i < (coordinates.count - 1); i++ {
            
            let source = MKPlacemark(coordinate: coordinates[i], addressDictionary: nil)
            let dest = MKPlacemark(coordinate: coordinates[i+1], addressDictionary: nil)
            
            var directionsRequest = MKDirectionsRequest()
            directionsRequest.setSource(MKMapItem(placemark: source))
            directionsRequest.setDestination(MKMapItem(placemark: dest))
            directionsRequest.transportType = MKDirectionsTransportType.Automobile
            var directions = MKDirections(request: directionsRequest)
            directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
                if error == nil {
                    let theRoute = response.routes[0] as? MKRoute
                    self.map.addOverlay(theRoute?.polyline)
                }
            }
        }
        
    }
    
    func setSelectedCoordinate(atIndex index: Int) {
        let newSelectedAnnotation = annotations[index]
        
        if newSelectedAnnotation == invalidAnnotation {
            if let selectedAnnotations = map.selectedAnnotations {
                map.deselectAnnotation(map.selectedAnnotations[0] as! QULAnnotation, animated: true)
            }
            return
        }
        
        self.selectedCoordinate = newSelectedAnnotation.coordinate
        
        //update previous annotation view
        //there is no update function so we add and remove to make mapview redraw the annotation
        if let selectedAnnotations = map.selectedAnnotations {
            let selectedAnnotation = map.selectedAnnotations.first as! QULAnnotation
            map.removeAnnotation(selectedAnnotation)
            map.addAnnotation(selectedAnnotation);
        }
        
        
        //update new annotatiov view
        map.removeAnnotation(newSelectedAnnotation)
        map.addAnnotation(newSelectedAnnotation);
        
        map.selectAnnotation(newSelectedAnnotation, animated: true)
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = self.routeColor
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return nil
    }
    
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
            }
            
            if (annotation.coordinate.latitude == self.selectedCoordinate?.latitude && annotation.coordinate.longitude == self.selectedCoordinate?.longitude) {
                view.pinColor = MKPinAnnotationColor.Purple
            } else {
                view.pinColor = MKPinAnnotationColor.Green
            }

            return view
        }
        return nil
    }
}
