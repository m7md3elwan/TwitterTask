//
//  AppFlowViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit

let KNotificationShowFollowersList = "KNotificationShowFollowersList"


class AppFlowViewController: UINavigationController {
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppFlowViewController.showFollowersList), name: NSNotification.Name(KNotificationShowFollowersList), object: nil)
        
        if User.shared.userInfo == nil {
            showLogin()
        } else {
            showFollowersList()
        }
    }
    
    // MARK:- Methods
    // MARK: Private methods
    fileprivate func showLogin() {
        let loginViewController = LoginViewController.instantiateFromStoryboard()
        setViewControllers([loginViewController], animated: true)
    }
    
    @objc fileprivate func showFollowersList() {
        let followersListViewController = FollowersListViewController.instantiateFromStoryboard()
        setViewControllers([followersListViewController], animated: true)
    }
}
