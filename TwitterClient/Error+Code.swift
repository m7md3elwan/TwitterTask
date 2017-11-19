//
//  Error+Code.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/19/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

let KErrorInternetConnection = -1009

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    
    func isNoInternet() -> Bool {
        return self.code == KErrorInternetConnection
    }
}
