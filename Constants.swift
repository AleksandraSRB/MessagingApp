//
//  Constants.swift
//  MessagingApp
//
//  Created by Aleksandra Sobot on 28.5.24..
//

import Foundation

struct K {
    static let cellIdentifier = "Cell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let appName = "⚡️FlashChat"
    
    struct BrandColor {
        static let brandPurple = "BrandPurple"
        static let brandLightPurple = "BrandLightPurple"
        static let brandBlue = "BrandBlue"
        static let brandLightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

