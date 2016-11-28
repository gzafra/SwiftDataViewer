//
//  SDVRequestManager.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 20/06/16.
//
//

import UIKit

public protocol SDVDataManagerDelegate : NSObjectProtocol{
    func dataDidLoad(data: NSArray)
    func dataDidFailToLoad() // TODO: Should send a custom error object
    func refreshingData()
}

class SDVDataManager: NSObject {
    // MARK: Enums
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // MARK: Properties
    let remoteUrl = "https://dl.dropboxusercontent.com/u/49130683/nativeapp-test.json"
    let diskManager = SDVDiskManager()
    
    private var _lastCacheDate : NSDate? = nil
    var lastCacheDate : NSDate? {
        get {
            return self._lastCacheDate ?? NSUserDefaults.standardUserDefaults().objectForKey("lastCacheDate") as? NSDate
        }
        set {
            self._lastCacheDate = newValue
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "lastCacheDate")
        }
    }
    let cacheTimeInSeconds : Double! = 60*60
    var results = [SDVJsonItem]()
    var isLoading = false
    var delegate : SDVDataManagerDelegate! = nil
    var lastError : NSError? = nil
    
    // MARK: Data Methods
    func getData() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.refreshingData()
        })
        
        // TODO: Correct use would be to use first data cached in memory instead of data from disk
        if let lastCacheDate = lastCacheDate {
            let now = NSDate()
            let timeInterval: Double = now.timeIntervalSinceDate(lastCacheDate);
            
            // Check if we should still load cache from disk
            if timeInterval <= cacheTimeInSeconds {
                if let data = diskManager.loadFromDisk() {
                    do {
                        try self.parseJson(data)
                        return
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                }
            }
            
        }
        // No cache
        requestRemoteData()
    }
    
    func requestRemoteData() {
        let url: NSURL = NSURL(string: remoteUrl)!
        let ses = NSURLSession.sharedSession()
        let task = ses.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                try self.parseJson(data)

                if self.diskManager.saveToDisk(data) {
                    // Update cache time
                    self.lastCacheDate = NSDate()
                }

                return;
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            self.isLoading = false
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate.dataDidFailToLoad()
            })
        })
        task.resume()
    }
    
    // MARK: JSON Utility Methods
    
    func parseJson(data: NSData) throws{
        guard let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
            throw JSONError.ConversionFailed
        }
        
        self.results.removeAll()
        
        if let jsonResult = jsonResult as? [String : AnyObject]{
            for (key, item) in jsonResult{
                if key == Constants.JsonKeys.currencyKey {
                    SDVConfigManager.sharedInstance.appCurrency = SDVConfigManager.Currency(rawValue: item as! String)
                }else if key == Constants.JsonKeys.dataKey {
                    if let dataArray = item as? NSArray{
                        for dataItem in dataArray{
                            if let itemDict = dataItem as? [String : AnyObject]{
                                let itemResult = SDVJsonItem(itemDict)
                                self.results.append(itemResult)
                            }
                        }
                    }
                }
            }
        }
        
        
        
        self.isLoading = false
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.dataDidLoad(self.results)
        })
    }
    

}
