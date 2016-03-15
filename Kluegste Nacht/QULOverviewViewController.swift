//
//  QULOverviewViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 18/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULOverviewViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedViewController: UIViewController!
    var containerViewController: QULGenericContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedOverviewContainer" {
            containerViewController = segue.destinationViewController as! QULGenericContainerViewController
            containerViewController.firstViewControllerSegueIdentifier = "showTopics"
            containerViewController.secondViewControllerSegueIdentifier = "showParticipants"
        }
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
            case 0:
                // selected Topics
                break
            case 1:
                // selected Participants
                break
            default:
            break;
        }
        
        containerViewController.cycleViewControllers()
    }
}