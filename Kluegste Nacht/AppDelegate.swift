//
//  AppDelegate.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 21/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setAppearance()
        
        QULDataSource.sharedInstance.readData()
        QULDataSource.sharedInstance.updateRoutes()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }    
    
    /*
    * Appearance: black, gray and yellow
    */
    func setAppearance() {
        /*
        * UITabBar appearance
        */
        // default text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState:.Normal)
        // selected text color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 210/255.0, blue: 4/255.0, alpha: 1.0)], forState:.Selected)
        
        /*
        * UINavigationBar appearance
        */
        // background color
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        // navigation elements color
        UINavigationBar.appearance().tintColor = UIColor(red: 255/255.0, green: 210/255.0, blue: 4/255.0, alpha: 1.0)
        // title color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        
        /*
        * UISwitch appearance
        */
        // border color
        UISwitch.appearance().tintColor = UIColor.lightGrayColor()
        // background color
        UISwitch.appearance().onTintColor = UIColor(
            red: 255.0/255.0,
            green: 210.0/255.0,
            blue: 4.0/255.0,
            alpha: 1.0)
    }
}