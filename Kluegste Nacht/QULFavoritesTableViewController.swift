//
//  QULFavoritesTableViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 03/06/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit
import Alamofire

class QULFavoritesTableViewController: UITableViewController {
    
    var stationInfo: NSDictionary!
    var data: Array<NSDictionary> = []
    let deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
    var host: String!
    var viewName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 290.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if host == nil {
            host = "http://favorites.kluegste-nacht.de/listv2/?d=\(deviceId)"
            viewName = "Favorites"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        Alamofire.request(.GET, host)
            .responseJSON { (_, _, JSON, _) in
                if !(JSON is NSNull) {
                    self.data = JSON as! Array<NSDictionary>
                    self.tableView.reloadData()
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEventStationOnMap" {
            let cityMapController = segue.destinationViewController as! QULCityMapViewController
            cityMapController.selectedStationId = (sender as! UIButton).tag
        }
    }
    
    @IBAction func didSelectLocationButton(sender: UIButton) {
        let point: CGPoint = tableView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = tableView!.indexPathForRowAtPoint(point)!
        performSegueWithIdentifier("showEventStationOnMap", sender: sender)
    }
    
    @IBAction func didSelectFavoriteButton(sender: UIButton) {
        let point: CGPoint = tableView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = tableView!.indexPathForRowAtPoint(point)!
        
        var route: NSDictionary = data[indexPath.section]
        var events = route["events"] as! Array<NSDictionary>
        let event: NSDictionary = events[indexPath.row]
        let eventId = event["id"] as! String
        
        let favorite = event["favorite"] as! Bool
        let markUnmark = favorite ? "unmark" : "mark"
        
        let urlString = "http://favorites.kluegste-nacht.de/\(markUnmark)/?id=\(eventId)&d=\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
        Alamofire.request(.GET, urlString)
            .responseString { (_, _, string, _) in
                
                if self.viewName == "Favorites" {
                    self.tableView.beginUpdates()
                    events.removeAtIndex(indexPath.row)
                    if events.count == 0 {
                        self.data.removeAtIndex(indexPath.section)
                        self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                    } else {
                        var newRoute:NSDictionary = route.mutableCopy() as! NSDictionary
                        newRoute.setValue(events, forKey: "events")
                        self.data[indexPath.section] = newRoute
                        
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    
                    self.tableView.endUpdates()
                } else {
                    sender.selected = !favorite
                }
        }
    }
    
    
    @IBAction func didSelectShareButton(sender: UIButton) {
        let point: CGPoint = tableView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = tableView!.indexPathForRowAtPoint(point)!
        
        let route: NSDictionary = data[indexPath.section]
        let events = route["events"] as! Array<NSDictionary>
        let event: NSDictionary = events[indexPath.row]
        
        
        let eventName = event["titel"] as! String
        
        let text = "\(eventName) #lndw2015"
        let appURL: NSURL! = NSURL(string: "http://app.kluegste-nacht.de")
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        
        self.presentViewController(activityViewController, animated: true) { () -> Void in
            let eventId = event["id"] as! String
        }
    }
}

extension QULFavoritesTableViewController : UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let route: NSDictionary = data[section]
        if let events = route["events"] as? Array<NSDictionary> {
            return events.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let route: NSDictionary = data[indexPath.section]
        let events = route["events"] as! Array<NSDictionary>
        var cell:QULExhibitionCell = tableView.dequeueReusableCellWithIdentifier("exhibitionCell") as! QULExhibitionCell
        cell.backgroundColor = UIColor.clearColor()
        let event: NSDictionary = events[indexPath.row]
        
        var content = ""
        if let description = event["beschreibung"] as? String {
            content += description
        }
        if let additionalText = event["zusatztext"] as? String {
            content += content == "" ? "" : "\n\n"
            content += additionalText
        }
        
        var additionalInformation = ""
        if let location = event["ort"] as? String {
            additionalInformation += "Ort: \(location)"
        }
        if let time = event["zeit"] as? String {
            additionalInformation += additionalInformation == "" ? "" : "\n"
            additionalInformation += "Zeit: \(time)"
        }
        if let subinstitution = event["untereinrichtung"] as? String {
            additionalInformation += additionalInformation == "" ? "" : "\n"
            additionalInformation += "Untereinrichtung: \(subinstitution)"
        }
        if let type = event["veranstaltungstyp"] as? String {
            additionalInformation += additionalInformation == "" ? "" : "\n"
            additionalInformation += "Veranstaltungstyp: \(type)"
        }
        if let accessible = event["barrierefrei"] as? String {
            var accessibleString: String
            switch accessible {
            case "0":
                accessibleString = "Nein"
            case "1":
                accessibleString = "Ja"
            default:
                accessibleString = "k.A."
            }
            additionalInformation += additionalInformation == "" ? "" : "\n"
            additionalInformation += "Barrierefrei: \(accessibleString)"
        }
        if let programForChildren = event["kinderprogramm"] as? String {
            var programForChildrenString: String
            switch programForChildren {
            case "0":
                programForChildrenString = "Nein"
            case "1":
                programForChildrenString = "Ja"
            case "2":
                programForChildrenString = "für Kinder unter 10 Jahren"
            case "3":
                programForChildrenString = "für Kinder ab 10 Jahren"
            default:
                programForChildrenString = "k.A."
            }
            additionalInformation += additionalInformation == "" ? "" : "\n"
            additionalInformation += "Kinderprogramm: \(programForChildrenString)"
        }
        
        if additionalInformation != "" {
            content += "\n\n" + additionalInformation
        }
        
        cell.contentLabel.text = content
        
        cell.titleLabel.text = event["titel"] as? String
        cell.coverImageView?.image = nil
        cell.coverImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.coverImageView.layer.masksToBounds = true
        cell.coverImageView.layer.cornerRadius = 5.0
        
        cell.favoriteButton.selected = event["favorite"] as! Bool
        cell.locationButton.tag = (event["stationId"] as! NSString).integerValue
        
        if let stationDict = QULDataSource.sharedInstance.station(cell.locationButton.tag)! as NSDictionary? {
            cell.locationButton.enabled = !(stationDict["geo1"] is NSNull)
        }
        
        
        if event["images"] != nil && !(event["images"] is NSNull) && event["images"]!.count > 0 {
            if let images = event["images"] as? Array<NSDictionary> {
                
                let imageDict = images[0]
                if let imageName = imageDict["datei"] as? String {
                    
                    let imageUrl = NSURL(string: "http://www.langenachtderwissenschaften.de/files/docs/resized/444x380/" + imageName)
                    let request: NSURLRequest = NSURLRequest(URL: imageUrl!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            let image = UIImage(data: data)
                            dispatch_async(dispatch_get_main_queue(), {
                                cell.coverImageView.image = image
                            })
                        }
                    })
                }
            }
        } else {
            cell.coverImageView.image = UIImage(named: "launchbg")
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let route: NSDictionary = data[section]
        if let headerTitle = route["name"] as? String {
            var header = QULExhibitionHeaderLabel()
            header.backgroundColor = UIColor.lightGrayColor()
            header.textColor = UIColor.darkGrayColor()
            header.numberOfLines = 0
            header.font = UIFont.boldSystemFontOfSize(14.0)
            header.lineBreakMode = NSLineBreakMode.ByWordWrapping
            header.text = headerTitle
            header.sizeToFit()
            
            return header
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let route: NSDictionary = data[section]
        if let headerTitle = route["name"] as? String {
            let rect = NSString(string: headerTitle).boundingRectWithSize(CGSizeMake(CGRectGetWidth(tableView.frame)-20.0,CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0)],
                context: nil)
            
            return max(CGRectGetHeight(rect), 38.0)
        }
        
        return 0
    }
    
}
