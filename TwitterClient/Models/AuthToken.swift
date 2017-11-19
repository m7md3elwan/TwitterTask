//
//  AuthToken.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/16/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

class AuthToken: NSObject, NSCoding {
    
    // MARK:- Constants
    struct keys {
        static let oauthToken = "oauthToken"
        static let oauthTokenSecret = "oauthTokenSecret"
        static let oauthVerifier = "oauthVerifier"
    }
    
    // MARK:- Variables
    var oauthToken: String
    var oauthTokenSecret: String?
    var oauthVerifier: String?
    
    init(oauthToken: String, oauthTokenSecret: String?, oauthVerifier: String?) {
        self.oauthToken = oauthToken
        super.init()
        self.oauthTokenSecret = oauthTokenSecret
        self.oauthVerifier = oauthVerifier
    }
    
    
    // MARK:- Encoding & Decoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.oauthToken, forKey: keys.oauthToken)
        aCoder.encode(self.oauthTokenSecret, forKey: keys.oauthTokenSecret)
        aCoder.encode(self.oauthVerifier, forKey: keys.oauthVerifier)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let oauthToken = aDecoder.decodeObject(forKey: keys.oauthToken) as? String {
            let oauthTokenSecret = aDecoder.decodeObject(forKey: keys.oauthTokenSecret) as? String
            let oauthVerifier = aDecoder.decodeObject(forKey: keys.oauthVerifier) as? String
            self.init(oauthToken: oauthToken, oauthTokenSecret: oauthTokenSecret, oauthVerifier: oauthVerifier)
        } else {
            return nil
        }

    }
}
