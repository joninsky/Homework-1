//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Jon Vogel on 1/7/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

import Foundation
import Social
import Accounts
import CoreData

class NetworkController {
  

  var twitterAccount: ACAccount?
  var imageQueue: NSOperationQueue = NSOperationQueue()
  
//  func initalizeTwitterAccount() -> ACAccount {
//    let myAccountStore = ACAccountStore()
//    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
//    var TA: ACAccount? //= ACAccount()
//    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotIt: Bool, error: NSError!) -> Void in
//      if gotIt == true {
//        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
//        if accountsArray.isEmpty == false {
//          TA = accountsArray[0] as? ACAccount
//        }
//      }
//    }
//    return TA!
//  }
  
  
  init () {

  }

  //Controller to Fetch Users Timeline
  func getTwitterUserTimeline(trailingClosure: ([Tweets]?, String?) -> ()) {
    let myAccountStore = ACAccountStore()
    //Create a variable of type ACAccountType by using the method accountTypeWithAccountTypeIdentifier thats in ACAccountStore
    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //this starts a new thread to access the account and do something with it in the clsure statement
    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotit: Bool , error: NSError!) -> Void in
      //If ACAccountStore was able to access the account the gotit boolean in the cluses will be true or false
      if gotit{
        //A user can have multiple accounts with each of these services, we load them all into the array.
        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
        //make sure we got at least one account
        if accountsArray.isEmpty == false{
          //We just want the first account that is stored in the array of account (there might only be one)
          self.twitterAccount = accountsArray[0] as? ACAccount
          //return twitterAccount

          //This is the URL for the JSON twitter request for hometimeline
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          //A request of type SLRequest, this starts a new thread.
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          //Set the SLRequests account property to the twitter accont that we got from the array of accounts
          twitterRequest.account = self.twitterAccount
          //call the performRequestWithHandler method on SLRequest (this starts a new thread) paramaters are the data that will be returned, the response code, and then an error
          twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
            //make a switch statement on the response code. You will probably get a basic server response code
            switch responseCode.statusCode{
              //If the response is good
            case 200...299:
              //create an array of json data that is typed as an array of [AnyObject]
              if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [AnyObject]{
                
                var arrayOfTweets: [Tweets] = [Tweets]()
                //println(jsonArray)
                //Loop through the array of json Data
                for t in jsonArray{
                  //set jsonDictionary equal one of the objects in the json array only if it can downcast to type [String: AnyObject]
                  if let jsonDictionary = t as? [String: AnyObject]{
                    //create a new Tweet object using the jsonDictionary object we have parsed down to
                    let tweet = Tweets(JSONDataForTweet: jsonDictionary)
                    //append it to the array of Tweets property
                    arrayOfTweets.append(tweet)
                    //Reload the UI On a new thread
                    
                  }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  trailingClosure(arrayOfTweets, nil)
                })
              }
              
              //If response is bad
            case 400...599:
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                trailingClosure(nil, "Bad error code \(responseCode.statusCode)")
              })
            default:
              println("Default Case")
            }
          })
        }
      }
    }
  }
  
  
  //Function to get one individual Tweet
  func getIndividualTweet(theTweetID: Int, completionHandler: (Tweets?, String?) -> ()){
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(theTweetID)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = self.twitterAccount
    twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
      switch responseCode.statusCode{
        //If the response is good
      case 200...299:
        //create an array of json data that is typed as an array of [AnyObject]
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String: AnyObject] {
          //Loop through the array of json Data
           //println(jsonDictionary)
          let theOneTweet = Tweets(JSONDataForTweet: jsonDictionary)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            
            completionHandler(theOneTweet, nil)
          })
        }
        //If response is bad
      case 400...599:
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(nil, "Bad error code \(responseCode.statusCode)")
        })
      default:
        println("Default Case")
      }
    })
  }
  
  //fetch user photo
  func fetchTweetImage(theTweet: Tweets, completionHandler: (UIImage?) -> ()){
    self.imageQueue.addOperationWithBlock { () -> Void in
      if let imageData = NSData(contentsOfURL: theTweet.imageURL){
        if let image = UIImage(data: imageData){
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(image)
          })
        }
      }
    }
  }
  
  //fetch user background photo
  func fetchTweetBackgroundImage(theTweet: Tweets, completionHandler: (UIImage?) -> ()){
    self.imageQueue.addOperationWithBlock { () -> Void in
      if let imageData = NSData(contentsOfURL: theTweet.backgroundImageURL){
        if let image = UIImage(data: imageData){
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(image)
          })
        }
      }
    }
  }
  
  //fetch a retweeters photo
  func fetchReTweetBackgroundImage(theTweet: Tweets, completionHandler: (UIImage?) -> ()){
    self.imageQueue.addOperationWithBlock { () -> Void in
      if let imageData = NSData(contentsOfURL: theTweet.retweeterImageURL!){
        if let image = UIImage(data: imageData){
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(image)
          })
        }
      }
    }
  }
  
  //get all the users tweets
  func getUsersTweets (userID: String, completionHandler: (theTweet: [Tweets]?, error: String?) -> ()){
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userID)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = self.twitterAccount
    twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
      println(responseCode.statusCode)
      switch responseCode.statusCode{
        //If the response is good
      case 200...299:
        //create an array of json data that is typed as an array of [AnyObject]
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [AnyObject] {
          //Loop through the array of json Data
          //println(jsonDictionary)
          var arrayOfTweets = [Tweets]()
          for t in jsonArray {
            if let jsonDictionary = t as? [String:AnyObject]{
              let tweet = Tweets(JSONDataForTweet: jsonDictionary)
              arrayOfTweets.append(tweet)
            }
          }
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(theTweet: arrayOfTweets, error: nil)
          })
        }
        //If response is bad
      case 400...599:
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(theTweet: nil, error: "Bad error code \(responseCode.statusCode)")
        })
      default:
        println("Default Case")
      }
    })
  }
  
  
//end Class
}