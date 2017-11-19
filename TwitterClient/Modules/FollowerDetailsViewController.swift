//
//  FollowerDetailsViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit
import HGPlaceholders
import SDWebImage

class FollowerDetailsViewController: UIViewController {
    
    // MARK: Properties
    var follower:Follower!
    var tweets = [String](){
        didSet {
            if tweets.count > 0 {
                self.tableView.showDefault()
            } else {
                self.tableView.showNoResultsPlaceholder()
            }
            tableView.reloadData()
        }
    }
    
    // MARK: Outlets
    @IBOutlet var tableView: TableView!
    @IBOutlet var followerImage: UIImageView!
    @IBOutlet var followerHeaderImage: UIImageView!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        localizeView()
        populateView()
        loadTweets()
    }
    
    // MARK:- Methods
    // MARK: Private methods
    fileprivate func populateView() {
        followerImage.sd_setImage(with: URL(string: follower.profilePicture ?? "")! , placeholderImage: #imageLiteral(resourceName: "twitterLogo"), options: SDWebImageOptions.progressiveDownload)
        followerHeaderImage.sd_setImage(with: URL(string: follower.profileBanner ?? "")! , placeholderImage: #imageLiteral(resourceName: "twitterLogo"), options: SDWebImageOptions.progressiveDownload)
        
        followerImage.layer.borderColor = UIColor.white.cgColor
        followerImage.layer.borderWidth = 2
        followerImage.layer.cornerRadius = 60
        followerImage.clipsToBounds = true
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.placeholdersProvider = PlaceholdersProvider.twitterPlaceHolders()
        tableView.tableFooterView = UIView()
        tableView.placeholderDelegate = self
    }
    
    fileprivate func loadTweets() {
        
        TwitterHelper.getTweets(user: User.shared.userInfo!, follower: self.follower) { (tweets, error) in
            guard error == nil else {
                if error!.isNoInternet() {
                    self.tableView.showNoConnectionPlaceholder()
                } else {
                    self.tableView.showErrorPlaceholder()
                }
                return
            }
            
            self.tweets = tweets!
        }
        
    }
    
    fileprivate func localizeView() {
    }
}

extension FollowerDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell")!
        if let tweetLabel = tweetCell.viewWithTag(1) as? UILabel {
            tweetLabel.text = tweets[indexPath.row]
        }
        return tweetCell
    }
    
    
}

extension FollowerDetailsViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        loadTweets()
    }
}
