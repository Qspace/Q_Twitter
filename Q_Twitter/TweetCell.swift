//
//  TweetCell.swift
//  Q_Twitter
//
//  Created by MAC on 11/28/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var reTweetTopViewIcon: UIImageView!
    
    @IBOutlet weak var reTweetedTopViewLabel: UILabel!
    
    @IBOutlet weak var tweetedUserLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAccountLabel: UILabel!
    
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var retweetUserName: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var reTweetButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    @IBOutlet weak var reTweetViewHeightConstraint: NSLayoutConstraint!

    
    
    
    
    var tweet: Tweet? {
        willSet(newTweet) {
            if newTweet?.isRetweetedStatus == false {
                hideReTweetTopView()
                showTweetOrg(newTweet)
            } else {
                print("Q_Debug: show top view")
                showReTweetTopView(newTweet)
                showTweetOrg(newTweet?.retweet)
            }
         
        }
    }
    
    func showTweetOrg(newTweet: Tweet?) {
        self.profileImage.setImageWithURL(NSURL(string: (newTweet?.user?.profileImageUrl)!)!)
        self.userNameLabel.text = newTweet?.user?.name
        self.userAccountLabel.text = "@\((newTweet?.user?.screenName)!)"
        self.tweetTextLabel.text = newTweet?.text
        self.tweetTimeLabel.text = TimeUtil.timeAgoSinceDate((newTweet?.createdAt)!, numericDates: true)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        replyButton.setImage(UIImage(named: "reply-action-default"), forState: .Normal)
        reTweetButton.setImage(UIImage(named: "retweet-action-default"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like-action-default"), forState: .Normal)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideReTweetTopView() {
        
        reTweetViewHeightConstraint.constant = 0
        retweetUserName.hidden = true
        reTweetTopViewIcon.hidden = true
        reTweetedTopViewLabel.hidden = true
    }
    
    func showReTweetTopView(newTweet: Tweet?) {
        reTweetViewHeightConstraint.constant = 27
        retweetUserName.hidden = false
        reTweetTopViewIcon.hidden = false
        reTweetedTopViewLabel.hidden = false
        
        self.retweetUserName.text = newTweet?.user?.name
    }
    
    @IBAction func onReply(sender: AnyObject) {
        replyButton.setImage(UIImage(named: "reply-action-pressed"), forState: .Normal)
    }
    
    @IBAction func onReTweet(sender: AnyObject) {
        reTweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
    }
    
    @IBAction func onLike(sender: AnyObject) {
        likeButton.setImage(UIImage(named: "like-action-pressed"), forState: .Normal)
    }
    
    

}
