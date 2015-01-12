//
//  Tweets.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/5/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import Foundation
import UIKit

class Tweets {
  
  var tweetDictionary: [String: AnyObject]
  var tweetText: String
  var userName: String
  var imageURL: NSURL
  var image: UIImage?
  var tweetID: Int
  var numberOfFollowers: Int?
  var numberOfPeopleFollowing: Int?
  var userID: String?
  var location: String?
  var isRetweet: Bool?
  var backgroundImageURL: NSURL
  var retweeterImageURL: NSURL?
  var retweeterTweetID: Int?
  
  init(JSONDataForTweet: [String: AnyObject]) {
    self.tweetDictionary = JSONDataForTweet
    self.tweetText = JSONDataForTweet["text"] as String
    let userDic = JSONDataForTweet["user"] as [String: AnyObject]
    self.userName = userDic["name"] as String
    self.imageURL = NSURL(string: userDic["profile_image_url"] as String)!
    self.backgroundImageURL = NSURL(string: userDic["profile_background_image_url_https"] as String)!
    self.tweetID = JSONDataForTweet["id"] as Int
  }
  
  
  func getTwoFs (){
    if let tempDic = tweetDictionary["user"] as? [String: AnyObject]{
    self.numberOfFollowers = tempDic["friends_count"] as? Int
    self.numberOfPeopleFollowing = tempDic["followers_count"] as? Int
    }else{
      self.numberOfPeopleFollowing = 0
      self.numberOfFollowers = 0
    }
  }
  
  
  func setUserID(){
    if let tempDic = tweetDictionary["user"] as? [String: AnyObject]{
      self.userID = tempDic["id_str"] as? String
    }
  }
  
  func setLocation() {
    if let tempDisc = tweetDictionary["user"] as? [String: AnyObject]{
      self.location = tempDisc["location"] as? String
    }
  }
  
  func setIsRetweet(){
    
      if let reTweetJson = tweetDictionary["retweeted_status"] as? [String:AnyObject]{
        self.retweeterTweetID = reTweetJson["id"] as? Int
        let tempUserDic = reTweetJson["user"] as [String: AnyObject]
        self.retweeterImageURL = NSURL(string: tempUserDic["profile_image_url"] as String)
        
        self.isRetweet = true
      }else{
        self.isRetweet = false
    }
  }
  
  
}