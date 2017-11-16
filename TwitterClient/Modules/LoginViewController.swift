//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: Properties
    // MARK: Outlets
    @IBOutlet var LoginButton: UIButton!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeView()
    }
    
    // MARK:- Methods
    // MARK: Actions
    @IBAction func LoginButtonTouchUpInside(_ sender: UIButton) {
        TwitterHelper.getRequestToken { (authToken, error) in
            guard error == nil else {
                // show error alert
            }
            
            // continue to login page
        }
    }

    // MARK: Private methods
    fileprivate func localizeView() {
    }
}
