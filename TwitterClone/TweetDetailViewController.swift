//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/7/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import Foundation
import UIKit

class TweetDetailViewController: UIViewController {
  
  var theTweetID: Int?
  var NC: NetworkController?
  var currentTweet: Tweets?
  
  @IBOutlet weak var btnUserImage: UIButton!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var lblTweetText: UILabel!
  @IBOutlet weak var lblFollowingCount: UILabel!
  @IBOutlet weak var lblFollowers: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NC!.getIndividualTweet(theTweetID!, completionHandler: { (currentTweet, error) -> () in
      if error == nil {
        self.currentTweet = currentTweet
        self.currentTweet?.getTwoFs()
        self.lblTweetText.text = self.currentTweet?.tweetText
        self.lblUserName.text = self.currentTweet?.userName
        var tempNumber = self.currentTweet!.numberOfFollowers ?? 0
        self.lblFollowers.text = "Followers: \(tempNumber)"
        tempNumber = currentTweet!.numberOfPeopleFollowing ?? 0
        self.lblFollowingCount.text = "Following: \(tempNumber)"
        let imageData = NSData(contentsOfURL: self.currentTweet!.imageURL)
        let tweetImage = UIImage(data: imageData!)
        self.btnUserImage.setImage(tweetImage, forState: UIControlState.Normal)
      }
    })
  }
  
  
  @IBAction func buttonPress(sender: AnyObject) {
    
    currentTweet?.setUserID()
    performSegueWithIdentifier("showUserProfile", sender: self)
    
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showUserProfile" {
      let DVC = segue.destinationViewController as UserTableViewController
      DVC.userID = currentTweet?.userID
      DVC.NC = self.NC
    }
  }
  
}