//
//  QULRoutesViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 19/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULRoutesViewController: UITableViewController {
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRoute" {
            
            let selectedIndexPath = tableView.indexPathForSelectedRow()
            
            let stationViewController: StationViewController = segue.destinationViewController as! StationViewController
            stationViewController.route = QULDataSource.sharedInstance.routesStations[selectedIndexPath!.row]
            stationViewController.stations = stationViewController.route["haltestellen"] as! NSArray
        }
    }    
}

extension QULRoutesViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QULDataSource.sharedInstance.routesStations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:QULRouteCell = tableView.dequeueReusableCellWithIdentifier("routeCell") as! QULRouteCell
        cell.backgroundColor = UIColor.clearColor()
        let dict: NSDictionary = QULDataSource.sharedInstance.routesStations[indexPath.row]
        
        if let name = dict["name"] as? String {
            cell.routeNameLabel.text = name
        }
        if let number = dict["number"] as? String {
          cell.routeNumberLabel.text = number
            
            var color: UIColor
            var extraColor = UIColor.clearColor()
            switch number {
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
                switch number {
                case "16":
                    extraColor = UIColor(red: 189.0/255.0, green: 205.0/255.0, blue: 2.0/255.0, alpha: 1.0)
                case "17":
                    extraColor = UIColor(red: 1.0/255.0, green: 158.0/255.0, blue: 224.0/255.0, alpha: 1.0)
                case "18":
                    extraColor = UIColor(red: 226.0/255.0, green: 0.0/255.0, blue: 122.0/255.0, alpha: 1.0)
                case "19":
                    extraColor = UIColor(red: 238.0/255.0, green: 127.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                default:
                    extraColor = UIColor.clearColor()
                }
            case "20","21","22":
                color = UIColor(red: 175.0/255.0, green: 8.0/255.0, blue: 23.0/255.0, alpha: 1.0)
            default:
                color = UIColor.whiteColor()
            }
            cell.routeNumberView.backgroundColor = color
            cell.routeNumberExtraView.backgroundColor = extraColor
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

extension QULRoutesViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRoute", sender: nil)
    }
}