//
//  UserTableViewController.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //Outlets for Header
  @IBOutlet weak var imgProfilePic: UIImageView!
  @IBOutlet weak var imgUserPic: UIImageView!
  @IBOutlet weak var lblUserFullName: UILabel!
  @IBOutlet weak var lblUserHandle: UILabel!
  @IBOutlet weak var lblFollowing: UILabel!
  @IBOutlet weak var lblFollowers: UILabel!
  
  
  
  
  
  
  @IBOutlet weak var myTableView: UITableView!
  var userID: String!
  var NC: NetworkController?
  var arrayOfUserTweets: [Tweets] = [Tweets]()
  var indexPathToSend: NSIndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println(userID)
    self.myTableView.delegate = self
    self.myTableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweetCell")
    self.myTableView.dataSource = self
    self.myTableView.estimatedRowHeight = 140
    self.myTableView.rowHeight = UITableViewAutomaticDimension
    
    NC?.getUsersTweets(userID, completionHandler: { (theArrayOfUserTweets, error) -> () in
      if error == nil {
        self.arrayOfUserTweets = theArrayOfUserTweets!
        self.myTableView.reloadData()
        self.setTableViewHeader()
      }
    })
  }
  
  
  
  func setTableViewHeader(){
   
    let theQuickTweet = arrayOfUserTweets[0]
    NC?.fetchTweetImage(theQuickTweet, completionHandler: { (imageToSet) -> () in
      self.imgUserPic.image = imageToSet
    })
    NC?.fetchTweetBackgroundImage(theQuickTweet, completionHandler: { (imageToSet) -> () in
      self.imgProfilePic.image = imageToSet
    })
    self.lblUserFullName.text = theQuickTweet.userName
    theQuickTweet.getTwoFs()
    theQuickTweet.setLocation()
    if theQuickTweet.location == "" {
      self.lblUserHandle.text = "Location: No Location Set"
    }else{
      self.lblUserHandle.text = "Location: \(theQuickTweet.location!)"
    }
    
    self.lblFollowers.text = "\(theQuickTweet.numberOfFollowers ?? 0) Followers"
    self.lblFollowing.text = "\(theQuickTweet.numberOfPeopleFollowing ?? 0) Following"
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayOfUserTweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let Cell = myTableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    let tweet = arrayOfUserTweets[indexPath.row]
    tweet.setIsRetweet()
    Cell.lblTweet.text = tweet.tweetText
    //println(tweet.tweetID)
    Cell.lblUser.text = tweet.userName
    if tweet.isRetweet == false {
      NC?.fetchTweetImage(tweet, completionHandler: { (imageToSet) -> () in
        Cell.btnImageButton.setImage(imageToSet, forState: UIControlState.Normal)
      })
    }else{
      NC?.fetchReTweetBackgroundImage(tweet, completionHandler: { (imageToSet) -> () in
        Cell.btnImageButton.setImage(imageToSet, forState: UIControlState.Normal)
      })
    }
    return Cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    indexPathToSend = indexPath
    performSegueWithIdentifier("backToTweetDetail", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "backToTweetDetail"{
    let DVC = segue.destinationViewController as TweetDetailViewController
    let tweet = arrayOfUserTweets[indexPathToSend!.row]
    tweet.setIsRetweet()
    //println(tweet.tweetDictionary)
    if tweet.isRetweet == true{
      DVC.theTweetID = tweet.retweeterTweetID
      println(tweet.retweeterTweetID)
    }else{
      DVC.theTweetID = tweet.tweetID
    }
    DVC.NC = self.NC
    }
  }
  
  
  
}