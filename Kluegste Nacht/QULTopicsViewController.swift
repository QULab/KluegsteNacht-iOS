//
//  QULTopicsViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 18/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit
import Alamofire

class QULTopicsViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    var data: Array<NSDictionary> = []
    var searchResults = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://data.kluegste-nacht.de/rest/topics/")
            .responseJSON { (_, _, JSON, _) in
                if let topics = JSON as? [NSDictionary] {
                    self.data = topics
                    self.tableView.reloadData()
                }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.tintColor = UIColor(
            red: 255.0/255.0,
            green: 210.0/255.0,
            blue: 4.0/255.0,
            alpha: 1.0)
        var searchBarTextField = searchController.searchBar.valueForKey("searchField") as? UITextField
        searchBarTextField?.textColor = UIColor.lightGrayColor()
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.backgroundView = UIView() // get rid of white background above table header
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if searchController.active {
            searchController.active = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEventsForTopic" {
            let source = searchController.active ? searchResults : data
            let topic = source[tableView.indexPathForSelectedRow()!.row]["name"] as! String
            let topicIdString = source[tableView.indexPathForSelectedRow()!.row]["id"] as! String
            let favoritesController = segue.destinationViewController as! QULFavoritesTableViewController
            favoritesController.host = "https://data.kluegste-nacht.de/rest/eventsWithTopicv2/?id=\(topicIdString)&d=\(UIDevice.currentDevice().identifierForVendor.UUIDString)"
            favoritesController.title = topic
            favoritesController.viewName = "Topic"
        }
    }
    
    func receivedFreshData() {}
}

extension QULTopicsViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchResults.count
        } else {
            return data.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("topicCell") as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        let source = searchController.active ? searchResults : data
        
        cell.textLabel?.text = source[indexPath.row]["name"] as? String
        
        return cell
    }
}

extension QULTopicsViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showEventsForTopic", sender: tableView)
    }
}

extension QULTopicsViewController: UISearchControllerDelegate {
    func presentSearchController(searchController: UISearchController) {
    }
    
    func willPresentSearchController(searchController: UISearchController) {
    }
    
    func didPresentSearchController(searchController: UISearchController) {
    }
    
    func willDismissSearchController(searchController: UISearchController) {
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension QULTopicsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension QULTopicsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !searchController.active {
            return
        }
        
        let searchString = searchController.searchBar.text
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
        searchResults = (data as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        tableView.reloadData()
    }
}