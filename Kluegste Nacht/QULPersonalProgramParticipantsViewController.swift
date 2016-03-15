//
//  QULPersonalProgramParticipantsViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 14/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULPersonalProgramParticipantsViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let participants: Array<String> = ["Erwachsene","Kinder","Englisch-sprachig","mit Rollstuhl unterwegs"]
    var selectedParticipants: Array<String> = []
    var result = [String : AnyObject]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wer?"
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.flashScrollIndicators()
    }
        
    func didToggleParticipant(toggle: UISwitch) {
        
        let participant = participants[toggle.tag]
        
        if toggle.on {
            selectedParticipants.append(participant)
        } else {
            if let index = find(selectedParticipants, participant) {
                selectedParticipants.removeAtIndex(index)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // hand over selected participants
        let typeController:QULPersonalProgramTypeViewController = segue.destinationViewController as! QULPersonalProgramTypeViewController
        
        if (selectedParticipants.count > 0) {
            let mapping = [participants[0]: "e",
                participants[1]: "k",
                participants[2]: "en",
                participants[3]: "r"]
            var resultString = ""
            for (index, participant) in enumerate(selectedParticipants) {
                resultString += mapping[participant]!
                if index < (selectedParticipants.count - 1) {
                    resultString += "+"
                }
            }
            result["Participants"] = resultString
            println(resultString);
        }
        
        typeController.result = result
    }
}

extension QULPersonalProgramParticipantsViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("guideParticipantCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        var toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: Selector("didToggleParticipant:"), forControlEvents: UIControlEvents.ValueChanged)
        toggle.on = contains(selectedParticipants,participants[indexPath.row])
        
        cell.textLabel?.text = participants[indexPath.row]
        cell.accessoryView = toggle
        
        return cell
    }
}

