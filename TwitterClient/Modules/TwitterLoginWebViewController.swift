//
//  TwitterLoginWebViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/16/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit

class TwitterLoginWebViewController: UIViewController {

    struct constants {
        static var authenticateUrl = "https://api.twitter.com/oauth/authenticate?"
    }
    
    // MARK: - Outlets
    @IBOutlet var webView: UIWebView!
    
    // MARK: - Variables
    var onSuccessCompletion:(() -> Void)!
    var onFailureCompletion:(() -> Void)!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
    }
    
    func startLogin(with authToken: AuthToken, onSuccess successCompletion:(() -> Void)?, onFailure failureCompletion:(() -> Void)?){
        
        self.onSuccessCompletion = successCompletion
        self.onFailureCompletion = failureCompletion
        
        
        webView.loadRequest(URLRequest(url: URL(string: "\(constants.authenticateUrl)oauth_token=\(authToken.oauthToken)")!))
    }
    
    // MARK: - Actions
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion:
            {
                self.onFailureCompletion?()
        })
    }

}

extension TwitterLoginWebViewController: UIWebViewDelegate
{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if let url = request.url {
            if url.absoluteString.uppercased().contains(TwitterHelper.constants.callBackUrl.uppercased()) {
                
                if let oauth_token = getQueryStringParameter(url: url.absoluteString, param: "oauth_token"), let oauth_verifier = getQueryStringParameter(url: url.absoluteString, param: "oauth_verifier") {
                    
                    
                    
                } else {
                    dismiss(animated: true, completion:
                        {
                            self.onFailureCompletion?()
                    })
                    return false
                }
            }
        }
        
        return true
    }
    
}
