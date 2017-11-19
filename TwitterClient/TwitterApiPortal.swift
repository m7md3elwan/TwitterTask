//
//  TwitterApiPortal.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation
import Alamofire

typealias responseCallBack<T> = (T?,Error?) -> Void

public class TwitterApiPortal {
    
    // MARK:- Properties
    public static let baseURL: String = "https://api.twitter.com/"
    
    // MARK: EndPoints
    public enum Endpoints: String {
        case getRequestToken = "oauth/request_token"
        case getAccessToken = "oauth/access_token"
        case getFollowers = "1.1/followers/list.json"
    }
    
    // MARK:- Methods
    // MARK: Dictionary Methods
    static func postDictionary(endPoint:TwitterApiPortal.Endpoints, parameters:[String:Any] = [:], headers:[String:String] = [:], completionHandler: @escaping responseCallBack<String> )
    {
        TwitterApiPortal.request(endPoint: endPoint, method: .post, parameters: parameters, headers: headers, returningClass: String.self) { (object, error) in
            
            guard error == nil && object != nil else { completionHandler(object, error); return }
            
            completionHandler(object, nil)
            
            return
        }
    }
    
    static func getJson(endPoint:TwitterApiPortal.Endpoints, parameters:[String:Any] = [:], headers:[String:String] = [:], completionHandler: @escaping responseCallBack<[String:Any]> )
    {
        TwitterApiPortal.requestJson(endPoint: endPoint, method: .get, parameters: parameters, headers: headers, returningClass: [String:Any].self) { (object, error) in
            
            guard error == nil && object != nil else { completionHandler(object, error); return }
            
            completionHandler(object, nil)
            
            return
        }
    }
    
    
    // MARK: Generic Methods
    static func get<T>(endPoint:TwitterApiPortal.Endpoints, parameters:[String:String] = [:], headers:[String:String], returningClass: T.Type , completionHandler: @escaping responseCallBack<T>)
    {
        TwitterApiPortal.request(endPoint: endPoint, method: .get, parameters: parameters, headers: headers, returningClass: returningClass) { (object, error) in
            completionHandler(object, error)
        }
    }
    
    static func post<T>(endPoint:TwitterApiPortal.Endpoints, parameters:[String:String] = [:], headers:[String:String], returningClass: T.Type , completionHandler: @escaping responseCallBack<T>) {
        TwitterApiPortal.request(endPoint: endPoint, method: .post, parameters: parameters, headers: headers, returningClass: returningClass) { (object, error) in
            completionHandler(object, error)
        }
    }
    
    fileprivate static func requestJson<T>(endPoint:TwitterApiPortal.Endpoints, method:Alamofire.HTTPMethod, parameters:[String:Any], headers:[String:String] = [:], returningClass: T.Type, completionHandler: @escaping responseCallBack<T>)
    {
        
        Alamofire.request("\(baseURL)\(endPoint.rawValue)", method: method, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                if let data = response.result.value as? T
                {
                    completionHandler(data, nil)
                }
            case .failure(_):
                if let error = response.result.error {
                    completionHandler(nil, error)
                }
            }
        }
        
    }
    
    fileprivate static func request<T>(endPoint:TwitterApiPortal.Endpoints, method:Alamofire.HTTPMethod, parameters:[String:Any], headers:[String:String] = [:], returningClass: T.Type, completionHandler: @escaping responseCallBack<T>)
    {
        
        Alamofire.request("\(baseURL)\(endPoint.rawValue)", method: method, parameters: parameters, headers: headers).responseString { (response) in
            switch response.result {
                
            case .success(_):
                if let data = response.result.value as? T
                {
                    completionHandler(data, nil)
                }
            case .failure(_):
                if let error = response.result.error {
                    completionHandler(nil, error)
                }
            }
        }
        
    }
    
}
