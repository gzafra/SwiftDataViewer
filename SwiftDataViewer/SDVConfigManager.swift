//
//  DSVConfigManager.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 20/06/16.
//
//
import Foundation

class SDVConfigManager: NSObject {
    static let sharedInstance = SDVConfigManager()
    
    enum Currency : String {
        case GBP = "GBP"
        case EUR = "EUR"
        case USD = "USD"
        
        func toNSLocale() -> String! {
            return NSLocale.localeIdentifierFromComponents([NSLocaleCurrencyCode:self.rawValue])
        }
    }
    
    var appCurrency : Currency!

}
