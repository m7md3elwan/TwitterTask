//
//  Follower.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/19/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

class Follower: NSObject, NSCoding {
    
    struct keys {
        static let name = "name"
        static let screenName = "screen_name"
        static let id = "id"
        static let bio = "description"
        static let profilePicture = "profile_image_url_https"
        static let profoleBanner = "profile_banner_url"
    }
    
    var name: String
    var screenName: String //Handle
    var id: Int
    var bio: String?
    var profilePicture: String?
    var profileBanner: String?
    
    init(id:Int, name:String, screenName:String) {
        self.id = id
        self.name = name
        self.screenName = screenName
    }
    
    convenience init?(dict:[String:Any]) {
        
        guard let name = dict[keys.name] as? String, let screenName = dict[keys.screenName] as? String, let id = dict[keys.id] as? Int else {
            return nil
        }
        
        self.init(id:id, name:name, screenName:screenName)
        
        self.bio = dict[keys.bio] as? String ?? ""
        self.profilePicture = dict[keys.profilePicture] as? String ?? ""
        self.profileBanner = dict[keys.profoleBanner] as? String ?? ""
    }
    
    // MARK:- Encoding & Decoding
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: keys.name)
        aCoder.encode(self.screenName, forKey: keys.screenName)
        aCoder.encode(self.id, forKey: keys.id)
        aCoder.encode(self.bio, forKey: keys.bio)
        aCoder.encode(self.profilePicture, forKey: keys.profilePicture)
        aCoder.encode(self.profileBanner, forKey: keys.profoleBanner)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        if aDecoder.containsValue(forKey: keys.id){
            
            if let name = aDecoder.decodeObject(forKey: keys.name) as? String,
                let screenName = aDecoder.decodeObject(forKey: keys.screenName) as? String {
                self.init(id:aDecoder.decodeInteger(forKey: keys.id), name:name, screenName:screenName)
                self.bio = aDecoder.decodeObject(forKey:keys.bio) as? String ?? ""
                self.profilePicture = aDecoder.decodeObject(forKey:keys.profilePicture) as? String ?? ""
                self.profileBanner = aDecoder.decodeObject(forKey:keys.profoleBanner) as? String ?? ""
            } else {
                return nil
            }
        }  else {
            return nil
        }
    }
    
}
