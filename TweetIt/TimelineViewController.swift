//
//  TimelineViewController.swift
//  TweetIt
//
//  Created by Andrew Mogg on 7/23/16.
//  Copyright © 2016 Andrew Mogg. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: TWTRTimelineViewController {
    
    @IBOutlet var menu: UIBarButtonItem!
    // Stores the height and width of the view (for formatting)
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var menuButton: UIButton!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        navigationItem.title = "\(appDelegate.userName)'s Tweets"
        self.dataSource = TWTRUserTimelineDataSource(screenName: "\(appDelegate.userName)", APIClient: TWTRAPIClient())
        
        // Get the height and width of the view
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
        getUserData()
        
    }
    
    func getUserData()
    {
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json?user_id=\(appDelegate.twittderID)"
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            var json: NSDictionary?
            
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                //print("json: \(json)")
                
//                //Still need picture to show
//                if json!["profile_image_url"] != nil {
//                    
//                    if let url  = NSURL(string: json!["profile_image_url"] as! String),
//                        data = NSData(contentsOfURL: url)
//                    {
//                        self.appDelegate.userImage.image = UIImage(data: data)
//                    }
//                }
                if json!["name"] != nil {
                    self.appDelegate.name = json!["name"] as! String
                    print(self.appDelegate.name)
                    
                }
                if json!["location"] != nil {
                    self.appDelegate.location = json!["location"] as! String
                    print(self.appDelegate.location)
                    
                }
                if json!["followers_count"] != nil {
                    self.appDelegate.followers = json!["followers_count"] as! Int
                    print(self.appDelegate.followers)
                    
                }
                if json!["friends_count"] != nil {
                    print("frinds founds!")
                    self.appDelegate.friends = json!["friends_count"] as! Int
                    print(self.appDelegate.friends)
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
        
    }
    
    
    
    @IBAction func tweet(sender: UIBarButtonItem) {
        //        let composer = TWTRComposer()
        //
        //        // Called from a UIViewController
        //        composer.showFromViewController(self) { result in
        //            if (result == TWTRComposerResult.Cancelled) {
        //                print("Tweet composition cancelled")
        //            }
        //            else {
        //                print("Sending tweet!")
        //            }
        //        }
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            
            // User generated image
            let image = UIImage()
            
            // Create the card and composer
            let card = TWTRCardConfiguration.appCardConfigurationWithPromoImage(image, iPhoneAppID: "12345", iPadAppID: nil, googlePlayAppID: nil)
            let composer = TWTRComposerViewController(userID: session.userID, cardConfiguration: card)
            
            // Optionally set yourself as the delegate
            //composer.delegate = self
            
            // Show the view controller
            presentViewController(composer, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        Twitter.sharedInstance().sessionStore.logOutUserID(appDelegate.twittderID)
        print("signed out from \(appDelegate.twittderID)")
        performSegueWithIdentifier("logOut", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
