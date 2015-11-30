## Coderschoolvn Week 3: Twitter Client

This is a simple Twitter client written in Swift that uses Twitter's [REST APIs](https://dev.twitter.com/rest/public).

**Time spent**: 12 hours

I didn't have much free time this past week to work on this assignment. I do feel, however, after implementing the [Yelp App](https://github.com/jerrysu/CodePath-Yelp), that I've got the hang of Auto Layout and storyboarding. The work done on this project seemed straightforward to me and it was much easier to make fast progress.

### Walkthrough

![Walkthrough](Q_Twitter.gif)

### Requirements

All required specs were implemented. Some optional specs were implemented.

  * [x] User can sign in using OAuth login flow
  * [x] User can view last 20 tweets from their home timeline
  * [x] The current signed in user will be persisted across restarts
  * [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
  * [x] User can pull to refresh
  * [] User can compose a new tweet by tapping on a compose button.
  * [] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
  * [] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
  * [] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
  * [ ] Optional: Retweeting and favoriting should increment the retweet and favorite count.
  * [ ] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
  * [ ] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
  * [ ] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Installation

Run the following in command-line:


The following CocoaPods were used:

  * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
  * [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)

### License