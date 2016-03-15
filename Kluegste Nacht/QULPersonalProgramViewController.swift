//
//  QULPersonalProgramViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 13/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULPersonalProgramViewController: UIViewController  {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedViewController: UIViewController!
    var containerViewController: QULGenericContainerViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedContainerViewController" {
            containerViewController = segue.destinationViewController as! QULGenericContainerViewController
            containerViewController.firstViewControllerSegueIdentifier = "showGuide"
            containerViewController.secondViewControllerSegueIdentifier = "showFavorites"
        }
    }
    
    @IBAction func segmentChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                // selected Wegweiser
                break
            case 1:
                // selected Favorites
                break
            default:
                break;
        }
        
        containerViewController.cycleViewControllers()
    }
}