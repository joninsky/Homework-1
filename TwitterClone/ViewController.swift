//
//  ViewController.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/5/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
  var tweets = [Tweets]()
  var NC: NetworkController = NetworkController()
  var indexPathToUse: NSIndexPath?
  
  @IBOutlet weak var myTableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //set the data source of the table view to this class
    self.myTableView.dataSource = self
    self.myTableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweetCell")
    self.myTableView.delegate = self
    self.myTableView.estimatedRowHeight = 140
    self.myTableView.rowHeight = UITableViewAutomaticDimension
    NC.getTwitterUserTimeline { (tweets, status) -> () in
      if status == nil {
        self.tweets = tweets!
        self.myTableView.reloadData()
      }
    }
  }


  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var Cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    
    let tweet = tweets[indexPath.row]
    Cell.lblTweet.text = tweet.tweetText
    //println(tweet.tweetID)
    Cell.lblUser.text = tweet.userName
    NC.fetchTweetImage(tweet, completionHandler: { (imageToSet) -> () in
      Cell.btnImageButton.setImage(imageToSet, forState: UIControlState.Normal)
    })
    return Cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    indexPathToUse = indexPath
    performSegueWithIdentifier("showTweetDetail", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTweetDetail" {
      var DVC = segue.destinationViewController as TweetDetailViewController
      let tweet = tweets[indexPathToUse!.row]
      DVC.theTweetID = tweet.tweetID
      DVC.NC = self.NC
    }
  }
  
  
  
  
}


