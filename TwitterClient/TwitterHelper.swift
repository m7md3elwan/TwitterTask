//
//  TwitterHelper.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation
import Alamofire

public class TwitterHelper {
    
    // MARK: Constants
    public struct constants {
        static var consumerKey = "pQ9YvOEr79VoyipAQoRGEJ1h8"
        static var consumerSecret = "MmL4dw5LX2X8PvNfYrN6KqVRPV7fiSTW0krCCoSt1IOt40QbP5"
        static var accessToken = "3304483223-c17c1iJj3cd3vC3j7xYpjoh7x1DXW3AMHInTKvM"
        static var accessTokenSecret = "cUVKbqTcRLhWFQwrlqMZvt9lWteFVjm5mWYTwGXmxNXbV"
        static var signatureEncryptionMethod = "HMAC-SHA1"
        static var callBackUrl = "https://TwitterClientTask.com"
        
        static var signingKey: String {
            return "\(consumerSecret.twitterEncoded())&\(accessTokenSecret.twitterEncoded())"
        }
    }
    
    // MARK:- Methods
    // MARK:- Public methods
    static func getRequestToken(completion:@escaping(_ token: AuthToken?,_ error: Error?)-> Void) {
        
        var parmeters = [String:String]()
        parmeters["oauth_callback"] = constants.callBackUrl
        parmeters["oauth_consumer_key"] = constants.consumerKey
        parmeters["oauth_nonce"] = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        parmeters["oauth_signature_method"] = constants.signatureEncryptionMethod
        parmeters["oauth_timestamp"] = "\(Int(Date().timeIntervalSince1970))"
        parmeters["oauth_version"] = "1.0"
        parmeters["oauth_signature"] = getSignatureStirng(method: .post, urlString: "\(TwitterApiPortal.baseURL)\(TwitterApiPortal.Endpoints.getRequestToken.rawValue)", parameters: parmeters, signingKey: "\(constants.consumerSecret.twitterEncoded())&")
        
        let authorizationHeaders = ["Authorization":getAuthorizationStirng(parameters: parmeters)]
        
        TwitterApiPortal.postDictionary(endPoint: TwitterApiPortal.Endpoints.getRequestToken, parameters: [:], headers: authorizationHeaders) { (tokenString, error) in
            
            guard error == nil else { completion(nil, error); return  }
            guard tokenString != nil else { completion(nil, NSError(domain: "TwitterClient", code: 1, userInfo: nil)); return  }
            
            if let oauthToken = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "oauth_token"), let oauthTokenSecret = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "oauth_token_secret") {
                let token = AuthToken(oauthToken: oauthToken, oauthTokenSecret: oauthTokenSecret, oauthVerifier: nil)
                completion(token, nil)
            } else {
                completion(nil, error); return
            }
        }
    }
    
    static func getAccessToken(token: AuthToken, completion:@escaping(_ userInfo: UserInfo?,_ error: Error?)-> Void) {
        
        var headerParmeters = [String:String]()
        headerParmeters["oauth_consumer_key"] = constants.consumerKey
        headerParmeters["oauth_nonce"] = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        headerParmeters["oauth_signature_method"] = constants.signatureEncryptionMethod
        headerParmeters["oauth_timestamp"] = "\(Int(Date().timeIntervalSince1970))"
        headerParmeters["oauth_version"] = "1.0"
        headerParmeters["oauth_token"] = token.oauthToken
        headerParmeters["oauth_signature"] = getSignatureStirng(method: .post, urlString: "\(TwitterApiPortal.baseURL)\(TwitterApiPortal.Endpoints.getAccessToken.rawValue)", parameters: headerParmeters, signingKey: "\(constants.consumerSecret.twitterEncoded())&")
        let authorizationHeaders = ["Authorization":getAuthorizationStirng(parameters: headerParmeters)]
        
        let parameters = ["oauth_verifier":"\(token.oauthVerifier!)"]
        
        TwitterApiPortal.postDictionary(endPoint: TwitterApiPortal.Endpoints.getAccessToken, parameters: parameters, headers: authorizationHeaders) { (tokenString, error) in
            
            guard error == nil else { completion(nil, error); return  }
            guard tokenString != nil else { completion(nil, NSError(domain: "TwitterClient", code: 1, userInfo: nil)); return  }
            
            if let oauthToken = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "oauth_token"),
                let oauthTokenSecret = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "oauth_token_secret"),
                let screenName = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "screen_name"),
                let user_id = getQueryStringParameter(url: "\(constants.callBackUrl)?\(tokenString!)", param: "user_id") {
                
                completion(UserInfo(oauthToken: oauthToken, oauthTokenSecret: oauthTokenSecret, screenName: screenName, userId: user_id), nil)
            } else {
                completion(nil, error); return
            }
        }
    }

    static func getFollowers(user: UserInfo, pageIndex: Int, completion:@escaping(_ followers: [Follower]?, _ nextCursor: Int?,_ error: Error?)-> Void) {
        
        var headerParmeters = [String:String]()
        headerParmeters["oauth_consumer_key"] = constants.consumerKey
        headerParmeters["oauth_nonce"] = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        headerParmeters["oauth_signature_method"] = constants.signatureEncryptionMethod
        headerParmeters["oauth_timestamp"] = "\(Int(Date().timeIntervalSince1970))"
        headerParmeters["oauth_version"] = "1.0"
        headerParmeters["oauth_token"] = user.token.oauthToken
        
        let parameters = ["screen_name":"\(user.screenName)",
            "user_id":"\(user.userId)",
            "cursor":"\(pageIndex)"]
        
        var signatureParameters = [String:String]()
        for (key,value) in headerParmeters {
            signatureParameters[key] = value
        }
        for (key,value) in parameters {
            signatureParameters[key] = value
        }
        
        headerParmeters["oauth_signature"] = getSignatureStirng(method: .get, urlString: "\(TwitterApiPortal.baseURL)\(TwitterApiPortal.Endpoints.getFollowers.rawValue)", parameters: signatureParameters, signingKey: "\(constants.consumerSecret.twitterEncoded())&\(user.token.oauthTokenSecret!.twitterEncoded())")
        
        
        let authorizationHeaders = ["Authorization":getAuthorizationStirng(parameters: headerParmeters)]
        

        
        TwitterApiPortal.getJson(endPoint: TwitterApiPortal.Endpoints.getFollowers, parameters: parameters, headers: authorizationHeaders) { (dict, error) in
            
            guard error == nil else { completion(nil, nil, error); return  }
            guard dict != nil else { completion(nil, nil, NSError(domain: "TwitterClient", code: 1, userInfo: nil)); return  }
            
            var followers = [Follower]()
            
            if let followersDict = dict!["users"] as? [[String:Any]] {
                
                for followerDict in followersDict {
                    if let follower = Follower(dict: followerDict) {
                        followers.append(follower)
                    }
                }
            }
            
            completion(followers, dict!["next_cursor"] as? Int , nil)
            
        }
    }
    
    
    
    // MARK:- Private methods
    static fileprivate func getAuthorizationStirng(parameters:[String:String]) -> String {
        var authorizationString: String = "OAuth "
        
        for (key,value) in Array(parameters).sorted(by: {$0.0 < $1.0}) {
            authorizationString = "\(authorizationString)\(key.twitterEncoded())=\"\(value.twitterEncoded())\","
        }
        
        // trim last ,
        authorizationString = authorizationString.substring(to: authorizationString.index(before: authorizationString.endIndex))
        
        return authorizationString
    }
    
    static fileprivate func getSignatureStirng(method:Alamofire.HTTPMethod, urlString: String, parameters:[String:String] = [:], signingKey:String) -> String {
        return getSignatureBaseStirng(method: method, urlString: urlString, parameters: parameters).hmac(algorithm: HMACAlgorithm.SHA1, key: signingKey)
    }
    
    static fileprivate func getSignatureBaseStirng(method:Alamofire.HTTPMethod, urlString: String, parameters:[String:String] = [:]) -> String
    {
        return "\(method.rawValue)&\(urlString.twitterEncoded())&\(getParametersStirng(parameters:parameters).twitterEncoded())"
    }
    
    static fileprivate func getParametersStirng(parameters:[String:String] = [:]) -> String
    {
        var encodedParameters = [String:String]()
        var parameterString = ""
        
        // fill encodedParameters
        for (key, value) in parameters {
            encodedParameters[key.twitterEncoded()] = value.twitterEncoded()
        }
        
        // perform on ordered parameters
        for (key,value) in Array(encodedParameters).sorted(by: {$0.0 < $1.0}) {
            parameterString = "\(parameterString)\(key)=\(value)&"
        }
        
        // trim last &
        parameterString = parameterString.substring(to: parameterString.index(before: parameterString.endIndex))
        
        return parameterString
    }
    
}
