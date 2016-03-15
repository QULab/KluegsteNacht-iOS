//
//  QULPersonalProgramLocationViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 14/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULPersonalProgramLocationViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var result = [String : AnyObject]()
    
    let locations: Array<String> = ["keine räumliche Einschränkung","Berlin-Buch","Treptow, Adlershof + Schöneweide","Treptow, Baumschulenweg","Treptow, Treptower Park","Neukölln, Buckow","Kreuzberg","Ostbahnhof + Jannowitzbrücke","Wedding + Mitte nördlicher Teil","Mitte südlicher Teil","Tiergarten, Hauptbahnhof + Moabit","Charlottenburg","Dahlem/Steglitz","Wannsee + Potsdam"]
    var selectedLocations: Array<String> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wo?"
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.flashScrollIndicators()
    }
        
    func didToggleLocation(toggle: UISwitch) {
        
        let location = locations[toggle.tag]
        
        if (toggle.tag == 0) {
            // "keine räumliche Einschränkung"
            for (index, location) in enumerate(locations) {
                // non visible cells crash
                if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) {
                    let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                    cellToggle.setOn(toggle.on, animated: true)
                }
                
            }
            
            if (toggle.on) {
                // select all locations
                selectedLocations = locations
            } else {
                // deselect all locations
                selectedLocations = []
            }
            
        } else {
            if let index = find(selectedLocations, locations[0]) {
                selectedLocations.removeAtIndex(index)
                
                if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                    let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                    if (cellToggle.on && !toggle.on) {
                        // deselect "keine räumliche Einschränkung"
                        cellToggle.setOn(false, animated: true)
                    }
                }
            }
            
            let location = locations[toggle.tag]
            if toggle.on {
                selectedLocations.append(location)
            } else {
                if let index = find(selectedLocations, location) {
                    selectedLocations.removeAtIndex(index)
                }
            }
        }
        
        if (selectedLocations.count == (locations.count - 1)) {
            // select "keine räumliche Einschränkung"
            selectedLocations = locations
            if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                
                if (!cellToggle.on) {
                    cellToggle.setOn(true, animated: true)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // hand over selected locations
        let timeController:QULPersonalProgramTimeViewController = segue.destinationViewController as! QULPersonalProgramTimeViewController
        
        if (find(selectedLocations,locations[0]) == nil && selectedLocations.count > 0) {
            // restrictions
            var resultString = ""
            for (index, location) in enumerate(selectedLocations) {
                let locationIndex = find(locations,location)
                resultString += String(locationIndex!)
                if index < (selectedLocations.count - 1) {
                    resultString += "+"
                }
            }
            result["Locations"] = resultString
            println(resultString);
        }
        
        timeController.result = result
    }
}

extension QULPersonalProgramLocationViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("guideLocationCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        var toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: Selector("didToggleLocation:"), forControlEvents: UIControlEvents.ValueChanged)
        toggle.on = contains(selectedLocations,locations[indexPath.row])
        
        cell.textLabel?.text = locations[indexPath.row]
        cell.accessoryView = toggle
        
        return cell
    }
}
