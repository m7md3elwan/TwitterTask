//
//  FollowerTableViewCell.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/19/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import UIKit
import SDWebImage

class FollowerTableViewCell: UITableViewCell {

    @IBOutlet var followerImage: UIImageView!
    @IBOutlet var followerNameLabel: UILabel!
    @IBOutlet var followerHandleNameLabel: UILabel!
    @IBOutlet var followerBioLabel: UILabel!
    
    
    func setup(with follower:Follower) {
        followerNameLabel.text = follower.name
        followerHandleNameLabel.text = follower.screenName
        followerBioLabel.text = follower.bio

        followerImage.sd_setImage(with: URL(string: follower.profilePicture ?? "")! , placeholderImage: #imageLiteral(resourceName: "twitterLogo"), options: SDWebImageOptions.progressiveDownload)
    }
    
}
