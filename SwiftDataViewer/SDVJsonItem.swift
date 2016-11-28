//
//  SDVJsonItem.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 20/06/16.
//
//

import UIKit

class SDVJsonItem: NSObject {
    var itemName : String!
    var jackpot : Int!
    var itemDate : String!
    
    override init () {
        super.init()
    }

    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.itemName = dictionary[Constants.JsonKeys.itemNameKey] as! String
        self.itemDate = dictionary[Constants.JsonKeys.itemDateKey] as! String
        self.jackpot = dictionary[Constants.JsonKeys.itemJackpot]!.integerValue
    }
}

extension Int {
    var asLocaleCurrency:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.init(localeIdentifier: SDVConfigManager.sharedInstance.appCurrency.toNSLocale())
        return formatter.stringFromNumber(self)!
    }
}

extension String {
    var asLocaleDate:String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+'SS:SS"

        
        if let parsedDateTimeString = formatter.dateFromString(self) {
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .NoStyle
            return formatter.stringFromDate(parsedDateTimeString)
        } else {
            print("ERROR: Could not parse date")
            return ""
        }
    }
}
