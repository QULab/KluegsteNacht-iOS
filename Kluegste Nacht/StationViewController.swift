//
//  StationViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 21/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation
import MapKit

class StationViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, StationViewDelegate  {
    
    //@IBOutlet weak var stationView: StationView!
    var stationView : StationView?
    @IBOutlet weak var mapViewController: QULMapViewController!
    
    var pageViewController: StationPageViewController?
    var route: NSDictionary!
    var stations = []
    var selectedStationIndex: Int?
    var pages: [QULExhibitionsTableViewController] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationView = StationView()
        
        navigationItem.titleView = stationView
        navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        stationView!.frame = CGRectMake(0, 0, navigationController!.navigationBar.frame.width*0.7, navigationController!.navigationBar.frame.height)
        if let routeIdString = route["number"] as? String {
            let color = StationViewController.colorForRoute(routeIdString)
            stationView?.stationButtonSelectedColor = color
            stationView?.stationButtonConnectionColor = color
        }        
        stationView!.setItems(stations as! Array<NSDictionary>)
        stationView!.delegate = self
        
        updateTitle()
        
        self.mapViewController.selectedCoordinate = CLLocationCoordinate2DMake(52.511752, 13.322597 )
        self.mapViewController.setStations(stations as! Array<NSDictionary>, routeDict: route)
        //self.mapViewController.setAnnotations()
        //self.mapViewController?.plotRoute(locations)

        
        //title = "Route 14"
        
    }
    
    


    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedStationIndex != nil {
            showStation(selectedStationIndex!)
        } else {
            self.mapViewController.setSelectedCoordinate(atIndex: 0)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "embed_pageViewController") {
            
            for (index,item) in enumerate(stations) {
                var viewController: QULExhibitionsTableViewController = UIStoryboard(
                    name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("QULExhibitionsTableViewController") as! QULExhibitionsTableViewController
                viewController.view.tag = index
                
                let stationDict: NSDictionary = item as! NSDictionary
                viewController.stationInfo = stationDict
                pages.append(viewController)
//                if let stationIdString = stationDict["id"] as? String {
//                    viewController.stationId = stationIdString.toInt()
//                    
//                }
            }
            
            
            
            pageViewController = segue.destinationViewController as? StationPageViewController
            pageViewController!.delegate = self
            pageViewController!.dataSource = self
            
            pageViewController!.setViewControllers([pages[0]],
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: true,
                completion: nil)
        }
    }
    
    func didSelectStation(station: Int) {
        showStation(station)
    }
    
    func showStation(station: Int) {
        let direction = (self.stationView!.currentStation > station) ? UIPageViewControllerNavigationDirection.Reverse : UIPageViewControllerNavigationDirection.Forward
        
        pageViewController!.setViewControllers([pages[station]],
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: true,
            completion: { (Bool) in
                self.stationView!.selectStation(station)
                self.updateTitle()
                self.mapViewController.setSelectedCoordinate(atIndex: station)
        })
    }
    
    func updateTitle() {
        //stationView.setStationTitle(items[stationView!.currentStation])
    }
    
    class func colorForRoute(routeIdString: String) -> UIColor {
        var color: UIColor
        switch routeIdString {
        case "1","2","3","4","5":
            color = UIColor(red: 0.0/255.0, green: 63.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        case "6":
            color = UIColor(red: 101.0/255.0, green: 176.0/255.0, blue: 148.0/255.0, alpha: 1.0)
        case "7","8","9","10","11","12","13":
            color = UIColor(red: 194.0/255.0, green: 0.0/255.0, blue: 97.0/255.0, alpha: 1.0)
        case "14":
            color = UIColor(red: 86.0/255.0, green: 95.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        case "15","16","17","18","19":
            color = UIColor(red: 250.0/255.0, green: 187.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case "20","21","22":
            color = UIColor(red: 175.0/255.0, green: 8.0/255.0, blue: 23.0/255.0, alpha: 1.0)
        default:
            color = UIColor.whiteColor()
        }
        
        return color
    }

    
}

// MARK: UIPageViewControllerDataSource
extension StationViewController : UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let current: Int = find(pages,viewController as! QULExhibitionsTableViewController)!
        
        return (current == 0)
            ? nil
            : pages[current-1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let current: Int = find(pages,viewController as! QULExhibitionsTableViewController)!
        
        return (current == pages.count - 1)
            ? nil
            : pages[current+1]
    }
}

// MARK: UIPageViewControllerDelegate
extension StationViewController : UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        let current: Int = find(pages,pendingViewControllers[0] as! QULExhibitionsTableViewController)!
        stationView!.selectStation(current)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (!completed) {
            let current: Int = find(pages,previousViewControllers[0] as! QULExhibitionsTableViewController)!
            stationView!.selectStation(current)
        } else {
            self.updateTitle()
            self.mapViewController.setSelectedCoordinate(atIndex: stationView!.currentStation)
        }
    }
}