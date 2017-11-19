//
//  FollowersListViewController.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/14/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit
import HGPlaceholders

class FollowersListViewController: UIViewController {
    
    // MARK: Properties
    var currentPage = -1
    var followers = [Follower](){
        didSet {
            if followers.count > 0 {
                self.tableView.showDefault()
            } else {
                self.tableView.showNoResultsPlaceholder()
            }
            tableView.reloadData()
        }
    }
    
    // MARK: Outlets
    @IBOutlet var tableView: TableView!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        localizeView()
        loadFollowers()
    }
    
    // MARK:- Methods
    // MARK: Actions
    
    // MARK: Public methods
    
    // MARK: Private methods
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.placeholdersProvider = PlaceholdersProvider.twitterPlaceHolders()
        tableView.tableFooterView = UIView()
        tableView.placeholderDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.addInfiniteScrollingWithHandler {
                self.loadFollowers()
            }
        }
    }
    
    fileprivate func loadFollowers() {
        
        if self.currentPage == -1 {
            self.followers.removeAll()
            self.tableView.showLoadingPlaceholder()
        }
        
        TwitterHelper.getFollowers(user: User.shared.userInfo!, pageIndex: currentPage) { [capturedPageIndex = self.currentPage] (followers, pageIndex, error) in
            
            
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            guard error == nil else {
                if capturedPageIndex == 0 {
                    if error!.isNoInternet() {
                        self.tableView.showNoConnectionPlaceholder()
                    } else {
                        self.tableView.showErrorPlaceholder()
                    }
                }
                return
            }
            
            if pageIndex != nil {
                self.currentPage = pageIndex!
            }
            
            var filteredRequests = [Follower]()
            for follower in followers!
            {
                if (self.followers.index{ $0.id == follower.id }) == nil
                {
                    filteredRequests.append(follower)
                }
            }
            self.followers.append(contentsOf: filteredRequests)
            
        }

    }
    
    fileprivate func localizeView() {
    }
}

extension FollowersListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FollowerTableViewCell") as! FollowerTableViewCell
        followerTableViewCell.setup(with: followers[indexPath.row])
        return followerTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}

extension FollowersListViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        loadFollowers()
    }
}
