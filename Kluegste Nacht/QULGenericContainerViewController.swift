//
//  QULGenericContainerViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 19/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class QULGenericContainerViewController: UIViewController {
    
    internal var currentViewController: UIViewController?
    internal var firstViewController: UIViewController?
    internal var secondViewController: UIViewController?
    
    var firstViewControllerSegueIdentifier: String!
    var secondViewControllerSegueIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSegueWithIdentifier(firstViewControllerSegueIdentifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == secondViewControllerSegueIdentifier {
            secondViewController = segue.destinationViewController as? UIViewController
            cycleViewControllers(firstViewController!, toViewController: secondViewController!)
        } else if segue.identifier == firstViewControllerSegueIdentifier {
            firstViewController = segue.destinationViewController as? UIViewController
            
            if childViewControllers.count > 0 {
                cycleViewControllers(childViewControllers[0] as! UIViewController, toViewController: firstViewController!)
            } else {
                addChildViewController(firstViewController!)
                var destinationView: UIView = firstViewController!.view
                destinationView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
                destinationView.frame = view.frame
                view.addSubview(destinationView)
                segue.destinationViewController.didMoveToParentViewController(self)
                
            }
        }
        
        currentViewController = segue.destinationViewController as? UIViewController
    }
    
    internal func cycleViewControllers(fromViewController: UIViewController, toViewController: UIViewController) {
        
        toViewController.view.frame = fromViewController.view.frame
        
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        
        transitionFromViewController(fromViewController,
            toViewController: toViewController,
            duration: 0.25,
            options: UIViewAnimationOptions.ShowHideTransitionViews,
            animations: nil,
            completion: { (success: Bool) -> Void in
                fromViewController.removeFromParentViewController()
                toViewController.didMoveToParentViewController(self)
        })
        
        
    }
    
    func cycleViewControllers() {
        
        if (currentViewController == firstViewController) {
            performSegueWithIdentifier(secondViewControllerSegueIdentifier, sender: nil)
        } else {
            performSegueWithIdentifier(firstViewControllerSegueIdentifier, sender: nil)
        }
    }
}
