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
                let alert = UIAlertController(title: "Error", message: "Failed to get Token", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "oK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let twitterLoginWebViewController = TwitterLoginWebViewController.instantiateFromStoryboard()
            self.present(twitterLoginWebViewController, animated: true, completion: { 
                twitterLoginWebViewController.startLogin(with: authToken!, onSuccess: {
                    print("Success")
                }, onFailure: { 
                    print("Failure")
                })
            })
            
        }
    }
    
    // MARK: Private methods
    fileprivate func localizeView() {
    }
}
