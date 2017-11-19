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
        TwitterHelper.getRequestToken { (requestToken, error) in
            guard error == nil else {
                self.showLoginError()
                return
            }
            
            let twitterLoginWebViewController = TwitterLoginWebViewController.instantiateFromStoryboard()
            self.present(twitterLoginWebViewController, animated: true, completion: { 

                twitterLoginWebViewController.startLogin(with: requestToken!, onSuccess: { (authToken) in
                    
                    TwitterHelper.getAccessToken(token: authToken, completion: { (userInfo, error) in
                        guard error == nil else {
                            self.showLoginError()
                            return
                        }

                        User.shared.userInfo = userInfo
                        NotificationCenter.default.post(name: Notification.Name(KNotificationShowFollowersList), object: nil)

                    })
                    
                }, onFailure: {
                    self.showLoginError()
                })
                
            })
            
        }
    }
    
    // MARK: Private methods
    fileprivate func showLoginError() {
        let alert = UIAlertController(title: "Error", message: "Failed to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "oK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func localizeView() {
    }
}
