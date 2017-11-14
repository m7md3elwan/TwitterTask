//
//  AppFlowViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit

class AppFlowViewController: UINavigationController {
    // MARK: Properties
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLogin()
    }
    
    // MARK:- Methods
    // MARK: Private methods
    fileprivate func showLogin() {
        let loginViewController = LoginViewController.instantiateFromStoryboard()
        setViewControllers([loginViewController], animated: true)
    }
    
    fileprivate func showFollowersList() {
        let followersListViewController = FollowersListViewController.instantiateFromStoryboard()
        setViewControllers([followersListViewController], animated: true)
    }
}
