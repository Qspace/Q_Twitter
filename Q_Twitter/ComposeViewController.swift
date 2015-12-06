//
//  ComposeViewController.swift
//  Q_Twitter
//
//  Created by MAC on 12/6/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAccountLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var replyTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
        userNameLabel.text = user?.name
        userAccountLabel.text = user?.screenName
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
        if replyTweet != nil {
            textView.text = "@\((replyTweet?.user?.screenName)!)"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        replyTweet = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTweet(sender: AnyObject) {
        let tweetContent = self.textView.text
        
        if replyTweet == nil {
            TwitClient.sharedInstance.updateTweet(tweetContent) { (tweet, error) -> () in
                if error != nil {
                    print("error post new tweet: \(error)")
                    return
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            if let id = replyTweet?.id {
                TwitClient.sharedInstance.replyStatus(tweetContent, tweetId: id, completion: { (tweet, error) -> () in
                    if error != nil {
                        print("error post reply tweet: \(error)")
                        return
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func onCancelTap(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
