//
//  QULPersonalProgramTypeViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 14/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import Foundation
import UIKit

class QULPersonalProgramTypeViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    let types: Array<String> = ["Zuhören","Mitmachen","Anschauen","Unterhalten lassen"]
    var selectedTypes: Array<String> = []
    var result = [String : AnyObject]()
    var resultUrlString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wie?"
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.flashScrollIndicators()
    }
    
    
    func didToggleType(toggle: UISwitch) {
        
        let type = types[toggle.tag]
        
        if toggle.on {
            selectedTypes.append(type)
        } else {
            if let index = find(selectedTypes, type) {
                selectedTypes.removeAtIndex(index)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let favoritesController = segue.destinationViewController as! QULFavoritesTableViewController
        favoritesController.host = resultUrlString!
        favoritesController.title = "Persönliche Auswahl"
        favoritesController.viewName = "GuideResult"
    }
    
    @IBAction func didSelectProgramCreation(sender: UIButton) {
        if (selectedTypes.count > 0) {
            
            let mapping = [types[0]: "z",
                types[1]: "m",
                types[2]: "a",
                types[3]: "u"]
            var resultString = ""
            for (index, type) in enumerate(selectedTypes) {
                resultString += mapping[type]!
                if index < (selectedTypes.count - 1) {
                    resultString += "+"
                }
            }
            result["Types"] = resultString
            println(resultString);
        }
        
        var url = "https://data.kluegste-nacht.de/rest/guide/?d=\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
        if let topics = result["Topics"] as? String {
            url += "&keywords=\(topics)"
        }
        if let types = result["Types"] as? String {
            url += "&type=\(types)"
        }
        if let participants = result["Participants"] as? String {
            url += "&participants=\(participants)"
        }
        if let routes = result["Locations"] as? String {
            url += "&routes=\(routes)"
        }
        if let timespan = result["Timespan"] as? [String:Double] {
            if let start = timespan["start"] {
                url += "&start=\(Int(start))"
            }
            if let end = timespan["end"] {
                url += "&end=\(Int(end))"
            }
        }
        resultUrlString = url
        let jsonResult = NSJSONSerialization.dataWithJSONObject(result, options: NSJSONWritingOptions.allZeros, error: nil)
        let jsonString = NSString(data: jsonResult!, encoding: NSUTF8StringEncoding)
        
        performSegueWithIdentifier("showGuideResult", sender: self)
    }
}

extension QULPersonalProgramTypeViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("guideTypeCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        var toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: Selector("didToggleType:"), forControlEvents: UIControlEvents.ValueChanged)
        toggle.on = contains(selectedTypes,types[indexPath.row])
        
        cell.textLabel?.text = types[indexPath.row]
        cell.accessoryView = toggle
        
        return cell
    }
}


