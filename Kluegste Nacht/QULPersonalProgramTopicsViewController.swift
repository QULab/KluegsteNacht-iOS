//
//  QULPersonalProgramTopicsViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 14/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULPersonalProgramTopicsViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let topics: Array<String> = ["Alles ist interessant","Technik","Naturwissenschaften","Geistes- und Sozialwissenschaften","Medizin","Interdisziplinär","Kunst, Musik, Theater"]
    var selectedTopics: Array<String> = []
    var result = [String : AnyObject]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Was?"
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.flashScrollIndicators()
    }
        
    func didToggleTopic(toggle: UISwitch) {
        
        let topic = topics[toggle.tag]
        
        if (toggle.tag == 0) {
            // "Alles ist interessant"
            for (index, topic) in enumerate(topics) {
                if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) {
                    let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                    cellToggle.setOn(toggle.on, animated: true)
                }
            }
            
            if (toggle.on) {
                // select all topics
                selectedTopics = topics
            } else {
                // deselect all topics
                selectedTopics = []
            }
            
        } else {
            if let index = find(selectedTopics, topics[0]) {
                selectedTopics.removeAtIndex(index)
                
                if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                    let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                    if (cellToggle.on && !toggle.on) {
                        // deselect "Alles ist interessant"
                        cellToggle.setOn(false, animated: true)
                    }
                }
            }
            
            let topic = topics[toggle.tag]
            if toggle.on {
                selectedTopics.append(topic)
            } else {
                if let index = find(selectedTopics, topic) {
                    selectedTopics.removeAtIndex(index)
                }
            }
        }
        
        if (selectedTopics.count == (topics.count - 1)) {
            // select "Alles ist interessant"
            selectedTopics = topics
            
            if let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
                let cellToggle:UISwitch = cell.accessoryView as! UISwitch
                
                if (!cellToggle.on) {
                    cellToggle.setOn(true, animated: true)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // hand over selected topics
        let participantsController:QULPersonalProgramParticipantsViewController = segue.destinationViewController as! QULPersonalProgramParticipantsViewController
        
        if (find(selectedTopics, topics[0]) == nil && selectedTopics.count > 0) {
            
            let mapping = [topics[1]: "t",
                topics[2]: "n",
                topics[3]: "g",
                topics[4]: "m",
                topics[5]: "i",
                topics[6]: "k"]
            var resultString = ""
            for (index, topic) in enumerate(selectedTopics) {
                resultString += mapping[topic]!
                if index < (selectedTopics.count - 1) {
                    resultString += "+"
                }
            }
            result["Topics"] = resultString
            println(resultString)
        }
        
        participantsController.result = result
    }
}

extension QULPersonalProgramTopicsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("guideTopicCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        var toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: Selector("didToggleTopic:"), forControlEvents: UIControlEvents.ValueChanged)
        toggle.on = contains(selectedTopics,topics[indexPath.row])
        
        cell.textLabel?.text = topics[indexPath.row]
        cell.accessoryView = toggle
        
        return cell
    }
}
