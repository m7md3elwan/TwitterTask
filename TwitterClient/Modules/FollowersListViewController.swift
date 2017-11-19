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
                User.shared.cahcedFollowers = followers
            } else {
                self.tableView.showNoResultsPlaceholder()
            }
            tableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FollowersListViewController.refreshFollowers), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
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
    // MARK: Private methods
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.placeholdersProvider = PlaceholdersProvider.twitterPlaceHolders()
        tableView.tableFooterView = UIView()
        tableView.placeholderDelegate = self
        
        tableView.addSubview(self.refreshControl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.addInfiniteScrollingWithHandler {
                self.loadFollowers()
            }
        }
    }
    
    func refreshFollowers() {
        self.currentPage = -1
        self.loadFollowers()
    }
    
    fileprivate func loadFollowers() {
        
        if self.currentPage == -1 {
            self.followers.removeAll()
            self.tableView.showLoadingPlaceholder()
        }
        
        refreshControl.endRefreshing()
        
        TwitterHelper.getFollowers(user: User.shared.userInfo!, pageIndex: currentPage) { [capturedPageIndex = self.currentPage] (followers, pageIndex, error) in
            
            self.tableView.infiniteScrollingView?.stopAnimating()
            
            guard error == nil else {
                if capturedPageIndex == -1 {
                    if error!.isNoInternet() {
                        if User.shared.cahcedFollowers.count > 0{
                            self.followers = User.shared.cahcedFollowers
                        } else {
                            self.tableView.showNoConnectionPlaceholder()
                        }
                    } else {
                        self.tableView.showErrorPlaceholder()
                    }
                }
                return
            }
            
            if pageIndex != nil {
                self.currentPage = pageIndex!
            }
            
            // check that list won't contain duplicates
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
        
        let followerDetailsViewController = FollowerDetailsViewController.instantiateFromStoryboard()
        followerDetailsViewController.follower = followers[indexPath.row]
        self.navigationController?.pushViewController(followerDetailsViewController, animated: true)
    }
}

extension FollowersListViewController: PlaceholderDelegate {
    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        loadFollowers()
    }
}
