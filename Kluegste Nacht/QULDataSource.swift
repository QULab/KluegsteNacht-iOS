//
//  QULDataSource.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 03/06/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import Foundation
import Alamofire

class QULDataSource {
    
    static let sharedInstance = QULDataSource()

    let documentsPath: String
    let fileDestination: String
    let host = "http://data.kluegste-nacht.de/rest/"
    var routesStations: Array<NSDictionary>!
    
    init() {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            self.documentsPath = dirs[0]
            self.fileDestination = self.documentsPath.stringByAppendingPathComponent("lndw.json")
        } else {
            self.documentsPath = ""
            self.fileDestination = ""
        }
    }
    
    func routes() -> Array<AnyObject?> {
        return []
    }
    
    func station(stationId: Int) -> NSDictionary? {
        for route in routesStations {
            if let stations = route["haltestellen"] as? NSArray {
                for station in stations {
                    let stationIdString = station["id"]
                    if (stationIdString as! NSString).integerValue == stationId {
                        return station as? NSDictionary
                    }
                }
            }
            
        }
        return nil
    }
    
    func updateRoutes() {
        Alamofire.request(.GET, host + "routen+haltestellen")
            .responseJSON { (_, _, JSON, _) in
                if JSON != nil {
                    var err: NSError?
                    var outputData : NSData? =  NSJSONSerialization.dataWithJSONObject(JSON!, options: .PrettyPrinted, error: &err)
                    self.saveData(outputData!)
                }
                
        }
    }
    
    func saveData(data: NSData) {
        var err: NSError?
        data.writeToFile(self.fileDestination, options: NSDataWritingOptions.DataWritingAtomic, error: &err)
    }
    
    func readData() {
        if let dataString = String(contentsOfFile: self.fileDestination, encoding: NSUTF8StringEncoding, error: nil) {
            var data: NSData = dataString.dataUsingEncoding(NSUTF8StringEncoding)!
        
            var err: NSError?
            let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err)
            
            routesStations = anyObj as! Array<NSDictionary>
        } else {
            loadInitialData()
        }
        
    }
    
    func loadInitialData() {
        let fileName = "Seed15"
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "json")
        let data: NSData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.allZeros, error: nil)!
        let json: Array<NSDictionary> = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as! Array<NSDictionary>
        
        routesStations = json
        
        var err: NSError?
        var outputData : NSData? =  NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted, error: &err)
        self.saveData(outputData!)
    }
    
}