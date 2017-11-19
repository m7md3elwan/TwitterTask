//
//  User.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/18/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    // MARK:- Constants
    struct constants {
        static let archivePath = "user"
        static let userInfo = "userInfo"
        static let userPreferedLanguage = "userPreferedLanguage"
        static let cachedFollowers = "cachedFollowers"
    }
    
    // MARK:- Singleton
    static var shared : User = {
        let instance = User()
        return instance
    }()
    
    // MARK:- Variables
    var userInfo: UserInfo?
    var cahcedFollowers = [Follower]()
    //    var userPreferedLanguage: ApplicationLanguage? {
    //        didSet {
    //            guard userPreferedLanguage != nil else {
    //                return
    //            }
    //            LanguageManager.shared.setAppLanguage(lang: userPreferedLanguage!)
    //        }
    //    }
    
    // MARK:- Encoding & Decoding
    public func encode(with aCoder: NSCoder) {
        //aCoder.encode(self.userPreferedLanguage?.rawValue, forKey: User.constants.userPreferedLanguage)
        aCoder.encode(self.cahcedFollowers, forKey: User.constants.cachedFollowers)
        aCoder.encode(self.userInfo, forKey: User.constants.userInfo)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        defer {
            // self.userPreferedLanguage = ApplicationLanguage(rawValue: aDecoder.decodeObject(forKey: constants.userPreferedLanguage) as? String ?? "en")
        }
        self.userInfo = aDecoder.decodeObject(forKey: constants.userInfo) as? UserInfo
        self.cahcedFollowers = aDecoder.decodeObject(forKey: constants.cachedFollowers) as? [Follower] ?? [Follower]()
    }
    
    
    
    // MARK:- Load & Save
    public static func archivePath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = "\(documentsPath!)/\(constants.archivePath)"
        return path
    }
    
    public static func saveSharedUser()
    {
        NSKeyedArchiver.archiveRootObject(User.shared, toFile: archivePath())
    }
    
    public static func loadSharedUser(){
        if let savedUser = NSKeyedUnarchiver.unarchiveObject(withFile: archivePath()) as? User {
            User.shared = savedUser
        }
    }
}
