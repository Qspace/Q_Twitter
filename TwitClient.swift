//
//  TwitClient.swift
//  Q_Twitter
//
//  Created by MAC on 11/25/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitBaseUrl = NSURL(string: "https://api.twitter.com")
let twitConsumerKey = "XmAHmKF0PA8qYauVRnXNANnQB"
let twitSecretKey =  "rI6GZlnGNKRQUaXyQGlq1YAeVvhvDl8AHqdYTaaLuuvnNm9z55"

class TwitClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?)->())?
    class var sharedInstance: TwitClient {
        struct Static {
            static let instance = TwitClient(baseURL: twitBaseUrl, consumerKey: twitConsumerKey, consumerSecret: twitSecretKey)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?,completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        // Get home timeline
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                print("text: \(tweet.text) \n created: \(tweet.createdAt)")
            }
            completion(tweets: tweets, error: nil)
            
            }, failure: { (opration: AFHTTPRequestOperation?, error: NSError) -> Void in
                print("Err getting home timeline",error)
                completion(tweets: nil, error: error)
        })
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> () ) {
        loginCompletion = completion
        
        TwitClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "qtwitter://oauth"), scope: nil, success: { (requestoken:BDBOAuth1Credential!) -> Void in
            print("Success request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestoken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error) -> Void in
                print("Err while request token")
                self.loginCompletion?(user: nil, error: error)
        }
        print("Q_Debug: LoginCompletion",loginCompletion)
    }
    
    func accessToken(url: NSURL) {
        TwitClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token")
            TwitClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // Get user
            TwitClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response: AnyObject) -> Void in
                let dict = response as? NSDictionary
                let user = User(dictionary: dict!)
                print("\(user.name)")
                // remember current user
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (oeration: AFHTTPRequestOperation?, error: NSError) -> Void in
                    print("Err getting current user \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            
            }) { (error: NSError!) -> Void in
                print("failed access token")
        }
    }
}


