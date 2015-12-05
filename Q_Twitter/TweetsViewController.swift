//
//  TweetsViewController.swift
//  Q_Twitter
//
//  Created by MAC on 11/28/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBarHidden = false
        navigationController?.title = "Tweet"
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        pullToRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        refreshData()
    }
    
    
    
    @IBAction func logOut(sender: AnyObject) {
        User.currentUser?.logOut()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        if tweets != nil {
            let tweet = tweets![indexPath.row] as Tweet
            cell.tweet = tweet
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("DetailTweetViewController") as! DetailTweetViewController
        controller.newTweet = self.tweets![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh Tweets")
        self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func refreshData() {
        print("Refresh Data")
        TwitClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
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
