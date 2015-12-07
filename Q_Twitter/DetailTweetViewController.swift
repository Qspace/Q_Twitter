//
//  DetailTweetViewController.swift
//  Q_Twitter
//
//  Created by MAC on 12/3/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var reTweetTopView: UIView!
    @IBOutlet weak var reTweetViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reTweetTopIcon: UIImageView!
    
    @IBOutlet weak var reTweetUserName: UILabel!
    @IBOutlet weak var reTweetedLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAccountLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreateDateLabel: UILabel!
    @IBOutlet weak var likesCntLabel: UILabel!
    @IBOutlet weak var reTweetsCntLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reTweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var replyCntLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var replyTexViewBottomConstraint:NSLayoutConstraint!
    @IBOutlet weak var replyViewBottomConstraint: NSLayoutConstraint!
    
    var newTweet: Tweet?
    var originTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set default image and congig image view display
        
        print("viewDidLoad")
        
        //Set up view
        replyButton.imageView?.sizeToFit()
        reTweetButton.imageView?.sizeToFit()
        likeButton.imageView?.sizeToFit()
        profileImage.layer.cornerRadius = 9.0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHiden:"), name:UIKeyboardWillHideNotification, object: nil)
        //Setup data
        originTweet = newTweet
        
        //Setup controller
        replyTextView.delegate = self
        
        showDetailView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        replyTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        replyTextView.text = "@\((newTweet?.user?.name)!)"
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.replyViewBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardWasHiden(notification: NSNotification) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.replyViewBottomConstraint.constant = 0
            
        })
    }
    
    
    func showDetailView() {
        print("Q_debug: show detail view")
        if newTweet?.isRetweetedStatus == false {
            hideReTweetTopView()
            showCurrentTweet(newTweet)
        } else {
            print("Q_Debug: show top view")
            showReTweetTopView(newTweet)
            showCurrentTweet(newTweet?.retweet)
        }
    }
    
    func showCurrentTweet(newTweet: Tweet?) {
        profileImage.setImageWithURL(NSURL(string: (newTweet?.user?.profileImageUrl)!)!)
        userNameLabel.text = newTweet?.user?.name
        userAccountLabel.text = "@\((newTweet?.user?.screenName)!)"
        tweetTextLabel.text = newTweet?.text
        tweetCreateDateLabel.text = newTweet?.createdAtString
        likesCntLabel.text = "\((newTweet?.likeCnt)!)"
        reTweetsCntLabel.text = "\((newTweet?.retweetCnt)!)"
        replyButton.setImage(UIImage(named: "reply-action-default"), forState: .Normal)
        
        if newTweet?.isLiked == true {
            likeButton.setImage(UIImage(named: "like-action-pressed"), forState: .Normal)
        } else {
            likeButton.setImage(UIImage(named: "like-action-default"), forState: .Normal)
        }
        
        if newTweet?.isRetweeted == true {
            reTweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
            
        } else {
            reTweetButton.setImage(UIImage(named: "retweet-action-default"), forState: .Normal)
            
        }
    }
    
    
    func hideReTweetTopView() {
        
        reTweetViewHeight.constant = 0
        reTweetTopIcon.hidden = true
        reTweetedLabel.hidden = true
        reTweetUserName.hidden = true
    }
    
    func showReTweetTopView(newTweet: Tweet?) {
        
        reTweetViewHeight.constant = 37
        reTweetTopIcon.hidden = false
        reTweetedLabel.hidden = false
        reTweetUserName.hidden = false
        
        reTweetTopIcon.image = UIImage(named: "retweet-action-pressed")
        self.reTweetUserName.text = newTweet?.user?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View will appear")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplyNavigationSegue"
        {
            if let destinationVC = segue.destinationViewController as? UINavigationController {
                let tagetVC = destinationVC.topViewController as! ComposeViewController
                tagetVC.replyTweet = self.newTweet
            }
        }
    }
    
    
    @IBAction func onReply(sender: AnyObject) {
        replyTextView.endEditing(true)
        replyTextView.text = ""
//        replyTextView.becomeFirstResponder()
        if let tweetContent = replyTextView.text {
            TwitClient.sharedInstance.replyStatus(tweetContent, tweetId: (self.newTweet?.id)!, completion: { (tweet, error) -> () in
                if error != nil {
                    print("error post reply tweet: \(error)")
                    return
                }
            })
        }
    }
    
    @IBAction func onReTweet(sender: AnyObject) {
        if newTweet?.isRetweeted == false {
            TwitClient.sharedInstance.retweet((newTweet?.id)!) { (tweet, error) -> () in
                if tweet != nil {
                    self.newTweet = tweet
                    self.showDetailView()
                } else {
                    print("Error call retweet API",error)
                }
            }
        } else {
            TwitClient.sharedInstance.unretweet((newTweet?.id)!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    print("Q_debug: untweet",tweet)
                    TwitClient.sharedInstance.getTweetWithId((self.originTweet?.id)!) { (tweet, error) -> () in
                        if tweet != nil {
                            self.newTweet = tweet
                            self.showDetailView()
                        } else {
                            print("Error call getTweet with ID API",error)
                        }
                    }
                } else {
                    print("Error call retweet API",error)
                }
            })
        }
        
    }
    
    @IBAction func onLike(sender: AnyObject) {
        if newTweet?.isLiked == false {
            TwitClient.sharedInstance.likeTweet((newTweet?.id)!) { (tweet, error) -> () in
                if tweet != nil {
                    self.newTweet = tweet
                    self.showDetailView()
                } else {
                    print("Error call like API",error)
                }
            }
        } else {
            TwitClient.sharedInstance.unlikeTweet((newTweet?.id)!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.newTweet = tweet
                    self.showDetailView()
                } else {
                    print("Error call unlike API",error)
                }
            })
        }
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
