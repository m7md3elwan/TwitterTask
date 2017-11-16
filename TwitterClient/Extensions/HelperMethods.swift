//
//  HelperMethods.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/16/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

static func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
}
