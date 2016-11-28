//
//  SDVDiskManager.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 21/06/16.
//
//

import UIKit

class SDVDiskManager: NSObject {
    let jsonFileName = "CachedData.json"
    let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    
    // MARK: Disk management
    
    func saveToDisk(jsonData: NSData!) -> Bool {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(jsonFileName)
            
            //writing
            do {
                try jsonData.writeToURL(path, options: .DataWritingAtomic)
                
                return true
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return false
    }
    
    func loadFromDisk() -> NSData?{
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(jsonFileName)
            
            let data = NSData(contentsOfURL: path)
            return data
        }
        return nil
    }

}
