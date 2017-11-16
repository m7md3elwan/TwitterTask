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
                let token = AuthToken(oauthToken: oauthToken, oauthTokenSecret: oauthTokenSecret)
                completion(token, nil)
            }
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
