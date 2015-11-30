//
//  Tweet.swift
//  Q_Twitter
//
//  Created by MAC on 11/27/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var isRetweetedStatus = false
    var isRetweeted = false
    var retweetCnt: Int?
    var likeCnt: Int?
    var isLiked = false
    var retweet: Tweet?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: (dictionary["user"] as! NSDictionary))
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        retweetCnt = dictionary["retweet_count"] as? Int!
        likeCnt = dictionary["favorite_count"] as? Int!
        
        isRetweeted = (dictionary["retweeted"] as? Bool!)!
        isLiked = (dictionary["favorited"] as? Bool!)!

//        isRetweeted == (dictionary["retweeted_status"] == nil) ? true : false
        if dictionary["retweeted_status"] == nil {
            isRetweetedStatus = false
            retweet = nil
        } else {
            isRetweetedStatus = true
            let reTweetDict = dictionary["retweeted_status"] as? NSDictionary
            retweet = Tweet(dictionary: reTweetDict!)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

}
