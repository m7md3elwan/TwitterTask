//
//  String+TwitterEncoding.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/16/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation

extension String {
    func twitterEncoded() -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}
