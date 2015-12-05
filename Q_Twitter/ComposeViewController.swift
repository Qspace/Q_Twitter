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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        profileImage.setImageWithURL(NSURL(string: (user?.profileImageUrl)!)!)
        userNameLabel.text = user?.name
        userAccountLabel.text = user?.screenName

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTweet(sender: AnyObject) {
        let tweet = self.textView.text
        
        TwitClient.sharedInstance.updateTweet(tweet) { (tweet, error) -> () in
            if error != nil {
                print("error post new tweet: \(error)")
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
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
