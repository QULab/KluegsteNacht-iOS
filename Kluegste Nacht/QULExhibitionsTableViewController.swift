//
//  QULExhibitionsTableViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 01/06/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class QULExhibitionsTableViewController: UITableViewController {
    
//    var stationId: Int!
    var stationInfo: NSDictionary!
    var routeSites: Array<NSDictionary> = []    
    var host = "http://data.kluegste-nacht.de/rest/eventsWithHaltestelle/?id="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 290.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let stationId = stationInfo["id"] as! String
        
        let urlString = host + stationId + "&d=\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
        Alamofire.request(.GET, urlString)
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil {
                    self.routeSites = JSON as! Array<NSDictionary>
                    self.tableView.reloadData()
                }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("didShowSwipeHint") {
            var contentView = PKHUDSubtitleView(subtitle: "Zum Wechseln der Station swipen!", image: UIImage(named: "Swipe"))
            PKHUD.sharedHUD.contentView = contentView
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.5)
            defaults.setBool(true, forKey: "didShowSwipeHint")
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
        
        let site: NSDictionary = routeSites[indexPath.section]
        let events = site["events"] as! Array<NSDictionary>
        let event: NSDictionary = events[indexPath.row]
        
        let eventId = event["id"] as! String
        
        let favorite = event["favorite"] as! Bool
        let markUnmark = favorite ? "unmark" : "mark"
        
        let urlString = "http://favorites.kluegste-nacht.de/\(markUnmark)/?id=\(eventId)&d=\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
        Alamofire.request(.GET, urlString)
            .responseString { (_, _, string, _) in
                sender.selected = !favorite
        }
    }
    
    
    @IBAction func didSelectShareButton(sender: UIButton) {
        let point: CGPoint = tableView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = tableView!.indexPathForRowAtPoint(point)!
        
        let site: NSDictionary = routeSites[indexPath.section]
        let events = site["events"] as! Array<NSDictionary>
        let event: NSDictionary = events[indexPath.row]
        
        let eventName = event["titel"] as! String
        let stationName = stationInfo["name"] as! String
        
        let text = "\(eventName) @ \(stationName) #lndw2015"
        let appURL: NSURL! = NSURL(string: "http://app.kluegste-nacht.de")
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        
        self.presentViewController(activityViewController, animated: true) { () -> Void in
            let eventId = event["id"] as! String
        }
    }
}

extension QULExhibitionsTableViewController : UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return routeSites.count == 0 ? 1 : routeSites.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if routeSites.count == 0 {
            return 1
        }
        
        let site: NSDictionary = routeSites[section]
        if let events = site["events"] as? Array<NSDictionary> {
            return events.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if routeSites.count == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("emptyCell") as! UITableViewCell
            let stationName = stationInfo["name"] as? String
            let stationChange = stationInfo["umstieg"] as? String
            var detailText = ""
            detailText += stationName != nil ? stationName! : ""
            detailText += stationChange != nil ? " (\(stationChange!))" : ""
            cell.detailTextLabel?.text = detailText
            cell.backgroundColor = UIColor.darkGrayColor()
            
            return cell
        }
        
        let site: NSDictionary = routeSites[indexPath.section]
        let events = site["events"] as! Array<NSDictionary>
        var cell:QULExhibitionCell = tableView.dequeueReusableCellWithIdentifier("exhibitionCell") as! QULExhibitionCell
        cell.backgroundColor = UIColor.darkGrayColor()
        
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
        cell.locationButton.tag = (stationInfo["id"] as! NSString).integerValue
        cell.locationButton.enabled = !(stationInfo["geo1"] is NSNull)
        
        if event["images"] != nil && event["images"]!.count > 0 {
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
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        if routeSites.count == 0 {
//            return ""
//        }
//        
//        let site: NSDictionary = routeSites[section]
//        return site["haus"] as? String
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if routeSites.count == 0 {
            return nil
        }
        
        let site: NSDictionary = routeSites[section]
        if let headerTitle = site["haus"] as? String {
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
        if routeSites.count == 0 {
            return 0
        }
        
        let site: NSDictionary = routeSites[section]
        if let headerTitle = site["haus"] as? String {
            let rect = NSString(string: headerTitle).boundingRectWithSize(CGSizeMake(CGRectGetWidth(tableView.frame)-20.0,CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0)],
                context: nil)
            
            return max(CGRectGetHeight(rect), 38.0)
        }
        
        return 0
    }
    
}

class QULExhibitionHeaderLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}