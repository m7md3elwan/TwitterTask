//
//  UserInfo.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/18/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

class UserInfo: NSObject, NSCoding {
    
    // MARK:- Constants
    struct constants {
        static let archivePath = "user"
        static let archivePathSubdirectory = "archive"
        static let token = "token"
        static let userPreferedLanguage = "userPreferedLanguage"
        static let screenName =  "screenName"
        static let userId = "userId"
    }
    
    // MARK:- Variables
    var token: AuthToken
    var screenName: String
    var userId: String

    // MARK:- Intializers
    init(oauthToken: String, oauthTokenSecret: String, screenName:String, userId:String) {
        self.token = AuthToken(oauthToken: oauthToken, oauthTokenSecret: oauthTokenSecret, oauthVerifier: nil)
        self.userId = userId
        self.screenName = screenName
    }
    
    init(token: AuthToken, screenName:String, userId:String) {
        self.token = token
        self.userId = userId
        self.screenName = screenName
    }
    
    
    // MARK:- Encoding & Decoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.token, forKey: UserInfo.constants.token)
        aCoder.encode(self.screenName, forKey: UserInfo.constants.screenName)
        aCoder.encode(self.userId, forKey: UserInfo.constants.userId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let token = aDecoder.decodeObject(forKey: constants.token) as? AuthToken,
            let screenName = aDecoder.decodeObject(forKey: constants.screenName) as? String,
            let userId = aDecoder.decodeObject(forKey: constants.userId) as? String {
            self.init(token: token, screenName: screenName, userId:userId)
        } else {
            return nil
        }
    }
}
